/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_party_eifsf1
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
drop table ${iml_schema}.pty_party_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_eifsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_party add partition p_eifsf1 values ('eifsf1')(
        subpartition p_eifsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_party modify partition p_eifsf1
    add subpartition p_eifsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_party_eifsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_party partition for ('eifsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_party_eifsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,party_name -- 当事人名称
    ,party_type_cd -- 当事人类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,src_party_type_cd -- 源当事人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_party
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_party_eifsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_party partition for ('eifsf1') where 0=1;

-- 2.1 insert data to tm table
-- eifs_t00_party_pub_info-1
insert into ${iml_schema}.pty_party_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,party_name -- 当事人名称
    ,party_type_cd -- 当事人类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,src_party_type_cd -- 源当事人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CUST_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.CUST_NUM -- 源当事人编号
    ,P1.CUST_NAME -- 当事人名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CUST_TYPE_CD END -- 当事人类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.CUST_OPEN_DT) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLOSE_DT) -- 失效日期
    ,' ' -- 源当事人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t00_party_pub_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t00_party_pub_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CUST_TYPE_CD = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'EIFS2'
        AND R1.SRC_TAB_EN_NAME= 'EIFS_T00_PARTY_PUB_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'CUST_TYPE_CD'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_PARTY'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PARTY_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- eifs_t01_corp_group_info-1
insert into ${iml_schema}.pty_party_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,party_name -- 当事人名称
    ,party_type_cd -- 当事人类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,src_party_type_cd -- 源当事人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.GROUP_NUM -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.GROUP_NUM -- 源当事人编号
    ,P1.GROUP_NAME -- 当事人名称
    ,'301004' -- 当事人类型代码
    ,to_date(to_char(P1.CREATED_TS,'yyyymmdd'),'yyyymmdd') -- 生效日期
    ,to_date('20991231','yyyymmdd') -- 失效日期
    ,' ' -- 源当事人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_group_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_group_info p1
    left join ${iol_schema}.eifs_t00_party_pub_info p2 on P1.GROUP_NUM=P2.CUST_NUM AND p2.start_dt<= to_date('${batch_date}','yyyymmdd') 
and p2.end_dt > to_date('${batch_date}','yyyymmdd') 
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    AND  p2.PARTY_ID is null
;
commit;

-- eifs_t01_corp_rel_corp_info-1
insert into ${iml_schema}.pty_party_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,party_name -- 当事人名称
    ,party_type_cd -- 当事人类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,src_party_type_cd -- 源当事人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.REL_ENTERP_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.RELA_NUM -- 源当事人编号
    ,P1.RELA_NAME -- 当事人名称
    ,'999999' -- 当事人类型代码
    ,trunc(P1.CREATED_TS) -- 生效日期
    ,to_date('20991231','yyyymmdd') -- 失效日期
    ,'CORP_RELA_CORP' -- 源当事人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_corp_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_rel_corp_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- eifs_t01_corp_rel_per_info-1
insert into ${iml_schema}.pty_party_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,party_name -- 当事人名称
    ,party_type_cd -- 当事人类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,src_party_type_cd -- 源当事人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.REL_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.RELA_NUM -- 源当事人编号
    ,P1.RELA_NAME -- 当事人名称
    ,'999999' -- 当事人类型代码
    ,to_date('19000101','yyyymmdd') -- 生效日期
    ,to_date('20991231','yyyymmdd') -- 失效日期
    ,'CORP_RELA_PS' -- 源当事人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_corp_rel_per_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_corp_rel_per_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- eifs_t01_per_rel_per_info-1
insert into ${iml_schema}.pty_party_eifsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,party_name -- 当事人名称
    ,party_type_cd -- 当事人类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,src_party_type_cd -- 源当事人类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.REL_ID -- 当事人编号
    ,'9999' -- 法人编号
    ,P1.RELA_NUM -- 源当事人编号
    ,P1.RELA_NAME -- 当事人名称
    ,'999999' -- 当事人类型代码
    ,trunc(P1.CREATED_TS) -- 生效日期
    ,to_date('20991231','yyyymmdd') -- 失效日期
    ,'PRIV_RELA_PS' -- 源当事人类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'eifs_t01_per_rel_per_info' -- 源表名称
    ,'eifsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.eifs_t01_per_rel_per_info p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_party_eifsf1_tm 
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
insert /*+ append */ into ${iml_schema}.pty_party_eifsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,src_party_id -- 源当事人编号
    ,party_name -- 当事人名称
    ,party_type_cd -- 当事人类型代码
    ,effect_dt -- 生效日期
    ,invalid_dt -- 失效日期
    ,src_party_type_cd -- 源当事人类型代码
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
    ,nvl(n.src_party_id, o.src_party_id) as src_party_id -- 源当事人编号
    ,nvl(n.party_name, o.party_name) as party_name -- 当事人名称
    ,nvl(n.party_type_cd, o.party_type_cd) as party_type_cd -- 当事人类型代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.invalid_dt, o.invalid_dt) as invalid_dt -- 失效日期
    ,nvl(n.src_party_type_cd, o.src_party_type_cd) as src_party_type_cd -- 源当事人类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.party_id is null
                and o.lp_id is null
            ) or (
                o.src_party_id <> n.src_party_id
                or o.party_name <> n.party_name
                or o.party_type_cd <> n.party_type_cd
                or o.effect_dt <> n.effect_dt
                or o.invalid_dt <> n.invalid_dt
                or o.src_party_type_cd <> n.src_party_type_cd
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
from ${iml_schema}.pty_party_eifsf1_tm n
    full join ${iml_schema}.pty_party_eifsf1_bk o
        on
            o.party_id = n.party_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_party truncate partition for ('eifsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_party exchange subpartition p_eifsf1_${batch_date} with table ${iml_schema}.pty_party_eifsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_party drop subpartition p_eifsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_party to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_party_eifsf1_tm purge;
drop table ${iml_schema}.pty_party_eifsf1_ex purge;
drop table ${iml_schema}.pty_party_eifsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_party', partname => 'p_eifsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);