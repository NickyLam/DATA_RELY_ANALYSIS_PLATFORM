/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_intstl_party_isbsf1
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
drop table ${iml_schema}.pty_intstl_party_isbsf1_tm purge;
drop table ${iml_schema}.pty_intstl_party_isbsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_intstl_party add partition p_isbsf1 values ('isbsf1')(
        subpartition p_isbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_intstl_party modify partition p_isbsf1
    add subpartition p_isbsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_intstl_party_isbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_intstl_party partition for ('isbsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_intstl_party_isbsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cn_name -- 中文名称
    ,intstl_cust_type_cd_comb -- 国结客户类型代码组合
    ,hq_party_id -- 总行当事人编号
    ,nation_crdt_level_cd -- 国家的信用等级代码
    ,risk_level_cd -- 风险等级代码
    ,risk_cty_cd -- 风险国家代码
    ,trans_lang_cd -- 传输语言代码
    ,edit_id -- 版本编号
    ,serv_level_cd -- 服务等级代码
    ,enty_group_id -- 实体组编号
    ,orgnz_cd -- 组织机构代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,resdnt_type_cd -- 居民类型代码
    ,belong_org_id -- 所属机构编号
    ,tran_main_cd -- 交易主体代码
    ,src_party_id -- 源当事人编号
    ,cbec_flg -- 跨境电商标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_intstl_party
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_intstl_party_isbsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_intstl_party partition for ('isbsf1') where 0=1;

-- 2.1 insert data to tm table
-- isbs_pty-1
insert into ${iml_schema}.pty_intstl_party_isbsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cn_name -- 中文名称
    ,intstl_cust_type_cd_comb -- 国结客户类型代码组合
    ,hq_party_id -- 总行当事人编号
    ,nation_crdt_level_cd -- 国家的信用等级代码
    ,risk_level_cd -- 风险等级代码
    ,risk_cty_cd -- 风险国家代码
    ,trans_lang_cd -- 传输语言代码
    ,edit_id -- 版本编号
    ,serv_level_cd -- 服务等级代码
    ,enty_group_id -- 实体组编号
    ,orgnz_cd -- 组织机构代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,resdnt_type_cd -- 居民类型代码
    ,belong_org_id -- 所属机构编号
    ,tran_main_cd -- 交易主体代码
    ,src_party_id -- 源当事人编号
    ,cbec_flg -- 跨境电商标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    'ISBS01'|| P1.INR -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.EXTKEY -- 客户编号
    ,P1.NAM -- 客户名称
    ,P1.NAM1 -- 中文名称
    ,P1.PTYTYP -- 国结客户类型代码组合
    ,P1.HEQINR -- 总行当事人编号
    ,case when R1.TARGET_CD_VAL is not null then R1.TARGET_CD_VAL else '@'|| P1.CLSCTY end  -- 国家的信用等级代码
    ,case when R2.TARGET_CD_VAL is not null then R2.TARGET_CD_VAL else '@'|| P1.RSKCLS end  -- 风险等级代码
    ,case when R3.TARGET_CD_VAL is not null then R3.TARGET_CD_VAL else '@'|| P1.RSKCTY end  -- 风险国家代码
    ,P1.UIL -- 传输语言代码
    ,P1.VER -- 版本编号
    ,P1.SLA -- 服务等级代码
    ,P1.ETGEXTKEY -- 实体组编号
    ,P1.JUSCOD -- 组织机构代码
    ,nvl(trim(P1.IDTYP1),'0000') -- 证件类型代码
    ,P1.IDCODE -- 证件号码
    ,case when R5.TARGET_CD_VAL is not null then R5.TARGET_CD_VAL else '@'|| P1.IDTYPE end  -- 居民类型代码
    ,P1.BCHKEYINR -- 所属机构编号
    ,P1.TRNMAN -- 交易主体代码
    ,P1.INR -- 源当事人编号
    ,decode(trim(P1.ISCRB),'Y','1','','0',P1.ISCRB) -- 跨境电商标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'isbs_pty' -- 源表名称
    ,'isbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.isbs_pty p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLSCTY=R1.SRC_CODE_VAL
AND R1.SORC_SYS_CD='ISBS'
AND R1.SRC_TAB_EN_NAME='ISBS_PTY'
AND R1.SRC_FIELD_EN_NAME='CLSCTY'
AND R1.TARGET_TAB_EN_NAME='PTY_INTSTL_PARTY'
AND R1.TARGET_TAB_FIELD_EN_NAME='NATION_CRDT_LEVEL_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.RSKCLS=R2.SRC_CODE_VAL
AND R2.SORC_SYS_CD='ISBS'
AND R2.SRC_TAB_EN_NAME='ISBS_PTY'
AND R2.SRC_FIELD_EN_NAME='RSKCLS'
AND R2.TARGET_TAB_EN_NAME='PTY_INTSTL_PARTY'
AND R2.TARGET_TAB_FIELD_EN_NAME='RISK_LEVEL_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.RSKCTY=R3.SRC_CODE_VAL
AND R3.SORC_SYS_CD='ISBS'
AND R3.SRC_TAB_EN_NAME='ISBS_PTY'
AND R3.SRC_FIELD_EN_NAME='RSKCTY'
AND R3.TARGET_TAB_EN_NAME='PTY_INTSTL_PARTY'
AND R3.TARGET_TAB_FIELD_EN_NAME='RISK_CTY_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.IDTYPE=R5.SRC_CODE_VAL
AND R5.SORC_SYS_CD='ISBS'
AND R5.SRC_TAB_EN_NAME='ISBS_PTY'
AND R5.SRC_FIELD_EN_NAME='IDTYPE'
AND R5.TARGET_TAB_EN_NAME='PTY_INTSTL_PARTY'
AND R5.TARGET_TAB_FIELD_EN_NAME='RESDNT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_intstl_party_isbsf1_tm 
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
insert /*+ append */ into ${iml_schema}.pty_intstl_party_isbsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,cn_name -- 中文名称
    ,intstl_cust_type_cd_comb -- 国结客户类型代码组合
    ,hq_party_id -- 总行当事人编号
    ,nation_crdt_level_cd -- 国家的信用等级代码
    ,risk_level_cd -- 风险等级代码
    ,risk_cty_cd -- 风险国家代码
    ,trans_lang_cd -- 传输语言代码
    ,edit_id -- 版本编号
    ,serv_level_cd -- 服务等级代码
    ,enty_group_id -- 实体组编号
    ,orgnz_cd -- 组织机构代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,resdnt_type_cd -- 居民类型代码
    ,belong_org_id -- 所属机构编号
    ,tran_main_cd -- 交易主体代码
    ,src_party_id -- 源当事人编号
    ,cbec_flg -- 跨境电商标志
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
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.cn_name, o.cn_name) as cn_name -- 中文名称
    ,nvl(n.intstl_cust_type_cd_comb, o.intstl_cust_type_cd_comb) as intstl_cust_type_cd_comb -- 国结客户类型代码组合
    ,nvl(n.hq_party_id, o.hq_party_id) as hq_party_id -- 总行当事人编号
    ,nvl(n.nation_crdt_level_cd, o.nation_crdt_level_cd) as nation_crdt_level_cd -- 国家的信用等级代码
    ,nvl(n.risk_level_cd, o.risk_level_cd) as risk_level_cd -- 风险等级代码
    ,nvl(n.risk_cty_cd, o.risk_cty_cd) as risk_cty_cd -- 风险国家代码
    ,nvl(n.trans_lang_cd, o.trans_lang_cd) as trans_lang_cd -- 传输语言代码
    ,nvl(n.edit_id, o.edit_id) as edit_id -- 版本编号
    ,nvl(n.serv_level_cd, o.serv_level_cd) as serv_level_cd -- 服务等级代码
    ,nvl(n.enty_group_id, o.enty_group_id) as enty_group_id -- 实体组编号
    ,nvl(n.orgnz_cd, o.orgnz_cd) as orgnz_cd -- 组织机构代码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.resdnt_type_cd, o.resdnt_type_cd) as resdnt_type_cd -- 居民类型代码
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.tran_main_cd, o.tran_main_cd) as tran_main_cd -- 交易主体代码
    ,nvl(n.src_party_id, o.src_party_id) as src_party_id -- 源当事人编号
    ,nvl(n.cbec_flg, o.cbec_flg) as cbec_flg -- 跨境电商标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.cust_id <> n.cust_id
                or o.cust_name <> n.cust_name
                or o.cn_name <> n.cn_name
                or o.intstl_cust_type_cd_comb <> n.intstl_cust_type_cd_comb
                or o.hq_party_id <> n.hq_party_id
                or o.nation_crdt_level_cd <> n.nation_crdt_level_cd
                or o.risk_level_cd <> n.risk_level_cd
                or o.risk_cty_cd <> n.risk_cty_cd
                or o.trans_lang_cd <> n.trans_lang_cd
                or o.edit_id <> n.edit_id
                or o.serv_level_cd <> n.serv_level_cd
                or o.enty_group_id <> n.enty_group_id
                or o.orgnz_cd <> n.orgnz_cd
                or o.cert_type_cd <> n.cert_type_cd
                or o.cert_no <> n.cert_no
                or o.resdnt_type_cd <> n.resdnt_type_cd
                or o.belong_org_id <> n.belong_org_id
                or o.tran_main_cd <> n.tran_main_cd
                or o.src_party_id <> n.src_party_id
                or o.cbec_flg <> n.cbec_flg
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
from ${iml_schema}.pty_intstl_party_isbsf1_tm n
    full join ${iml_schema}.pty_intstl_party_isbsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_intstl_party truncate partition for ('isbsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_intstl_party exchange subpartition p_isbsf1_${batch_date} with table ${iml_schema}.pty_intstl_party_isbsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_intstl_party drop subpartition p_isbsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_intstl_party to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_intstl_party_isbsf1_tm purge;
drop table ${iml_schema}.pty_intstl_party_isbsf1_ex purge;
drop table ${iml_schema}.pty_intstl_party_isbsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_intstl_party', partname => 'p_isbsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);