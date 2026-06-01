/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_am_cntpty_info_famsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.pty_am_cntpty_info_famsf1_tm purge;
drop table ${iml_schema}.pty_am_cntpty_info_famsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_am_cntpty_info add partition p_famsf1 values ('famsf1')(
        subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_am_cntpty_info modify partition p_famsf1
    add subpartition p_famsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_am_cntpty_info_famsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_am_cntpty_info partition for ('famsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_am_cntpty_info_famsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cntpty_id -- 交易对手编号
    ,cntpty_abbr -- 交易对手简称
    ,cntpty_name -- 交易对手名称
    ,cntpty_flg -- 交易对手标志
    ,cntpty_cls_cd -- 交易对手分类代码
    ,corp_lev_cd -- 公司级别代码
    ,valid_flg -- 有效标志
    ,trust_b_flg -- 托管行标志
    ,co_org_flg -- 合作机构标志
    ,bank_flg -- 银行标志
    ,indus_gen_cd -- 行业大类代码
    ,indus_type_cd -- 行业类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_am_cntpty_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_am_cntpty_info_famsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_am_cntpty_info partition for ('famsf1') where 0=1;

-- 2.1 insert data to tm table
-- fams_glb_cntparty-
insert into ${iml_schema}.pty_am_cntpty_info_famsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cntpty_id -- 交易对手编号
    ,cntpty_abbr -- 交易对手简称
    ,cntpty_name -- 交易对手名称
    ,cntpty_flg -- 交易对手标志
    ,cntpty_cls_cd -- 交易对手分类代码
    ,corp_lev_cd -- 公司级别代码
    ,valid_flg -- 有效标志
    ,trust_b_flg -- 托管行标志
    ,co_org_flg -- 合作机构标志
    ,bank_flg -- 银行标志
    ,indus_gen_cd -- 行业大类代码
    ,indus_type_cd -- 行业类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101004'||P1.GLCPUUID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.GLCPUUID -- 交易对手编号
    ,P1.ABBRNAME -- 交易对手简称
    ,P1.PARTYNAME -- 交易对手名称
    ,SUBSTR(P1.ORGNAME，4,1) -- 交易对手标志
    ,nvl(trim(P1.PAYTYGROUP),'0') -- 交易对手分类代码
    ,P1.COMLEVEL -- 公司级别代码
    ,P1.EFFECTFLAG -- 有效标志
    ,SUBSTR(P1.ORGNAME，3,1) -- 托管行标志
    ,SUBSTR(P1.ORGNAME，2,1) -- 合作机构标志
    ,SUBSTR(P1.ORGNAME，1,1) -- 银行标志
    ,case when P1.CHECKTYPE=' ' then '-' when P1.CHECKTYPE='AAA' then '-' else P1.CHECKTYPE end -- 行业大类代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||to_char(P1.INDUSTRY) END -- 行业类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fams_glb_cntparty' -- 源表名称
    ,'famsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fams_glb_cntparty p1
    left join ${iml_schema}.ref_pub_cd_map r2 on to_char(P1.INDUSTRY) = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FAMS'
        AND R2.SRC_TAB_EN_NAME= 'FAMS_GLB_CNTPARTY'
        AND R2.SRC_FIELD_EN_NAME= 'INDUSTRY'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_AM_CNTPTY_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'INDUS_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_am_cntpty_info_famsf1_tm 
  	                                group by 
  	                                        party_id
  	                                        ,lp_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.pty_am_cntpty_info_famsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cntpty_id -- 交易对手编号
    ,cntpty_abbr -- 交易对手简称
    ,cntpty_name -- 交易对手名称
    ,cntpty_flg -- 交易对手标志
    ,cntpty_cls_cd -- 交易对手分类代码
    ,corp_lev_cd -- 公司级别代码
    ,valid_flg -- 有效标志
    ,trust_b_flg -- 托管行标志
    ,co_org_flg -- 合作机构标志
    ,bank_flg -- 银行标志
    ,indus_gen_cd -- 行业大类代码
    ,indus_type_cd -- 行业类型代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.party_id, o.party_id) as party_id -- 当事人编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.cntpty_id, o.cntpty_id) as cntpty_id -- 交易对手编号
    ,nvl(n.cntpty_abbr, o.cntpty_abbr) as cntpty_abbr -- 交易对手简称
    ,nvl(n.cntpty_name, o.cntpty_name) as cntpty_name -- 交易对手名称
    ,nvl(n.cntpty_flg, o.cntpty_flg) as cntpty_flg -- 交易对手标志
    ,nvl(n.cntpty_cls_cd, o.cntpty_cls_cd) as cntpty_cls_cd -- 交易对手分类代码
    ,nvl(n.corp_lev_cd, o.corp_lev_cd) as corp_lev_cd -- 公司级别代码
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,nvl(n.trust_b_flg, o.trust_b_flg) as trust_b_flg -- 托管行标志
    ,nvl(n.co_org_flg, o.co_org_flg) as co_org_flg -- 合作机构标志
    ,nvl(n.bank_flg, o.bank_flg) as bank_flg -- 银行标志
    ,nvl(n.indus_gen_cd, o.indus_gen_cd) as indus_gen_cd -- 行业大类代码
    ,nvl(n.indus_type_cd, o.indus_type_cd) as indus_type_cd -- 行业类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.cntpty_id <> n.cntpty_id
                or o.cntpty_abbr <> n.cntpty_abbr
                or o.cntpty_name <> n.cntpty_name
                or o.cntpty_flg <> n.cntpty_flg
                or o.cntpty_cls_cd <> n.cntpty_cls_cd
                or o.corp_lev_cd <> n.corp_lev_cd
                or o.valid_flg <> n.valid_flg
                or o.trust_b_flg <> n.trust_b_flg
                or o.co_org_flg <> n.co_org_flg
                or o.bank_flg <> n.bank_flg
                or o.indus_gen_cd <> n.indus_gen_cd
                or o.indus_type_cd <> n.indus_type_cd
            ) or (
                 case when (
                           n.party_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.party_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_am_cntpty_info_famsf1_tm n
    full join ${iml_schema}.pty_am_cntpty_info_famsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_am_cntpty_info truncate partition for ('famsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_am_cntpty_info exchange subpartition p_famsf1_${batch_date} with table ${iml_schema}.pty_am_cntpty_info_famsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_am_cntpty_info drop subpartition p_famsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_am_cntpty_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_am_cntpty_info_famsf1_tm purge;
drop table ${iml_schema}.pty_am_cntpty_info_famsf1_ex purge;
drop table ${iml_schema}.pty_am_cntpty_info_famsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_am_cntpty_info', partname => 'p_famsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);