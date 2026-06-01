/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_pty_cust_fsmsf1
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
drop table ${iml_schema}.pty_cust_fsmsf1_tm purge;
drop table ${iml_schema}.pty_cust_fsmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.pty_cust add partition p_fsmsf1 values ('fsmsf1')(
        subpartition p_fsmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.pty_cust modify partition p_fsmsf1
    add subpartition p_fsmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.pty_cust_fsmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.pty_cust partition for ('fsmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_fsmsf1_tm
compress ${option_switch} for query high
as
select
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cust_id -- 客户编号
    ,cust_cate_cd -- 客户类别代码
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,cert_type_cd -- 证件类型代码
    ,open_acct_user_id -- 开户用户编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_dt -- 开户日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.pty_cust_fsmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.pty_cust partition for ('fsmsf1') where 0=1;

-- 2.1 insert data to tm table
-- fsms_com_cust_info-
insert into ${iml_schema}.pty_cust_fsmsf1_tm(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cust_id -- 客户编号
    ,cust_cate_cd -- 客户类别代码
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,cert_type_cd -- 证件类型代码
    ,open_acct_user_id -- 开户用户编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_dt -- 开户日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.BANK_CUST_CODE -- 当事人编号
    ,'9999' -- 法人编号
    ,'FSMS' -- 源系统代码
    ,TRIM(P1.CUST_NO) -- 客户编号
    ,' ' -- 客户类别代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.cust_type END -- 客户类型代码
    ,P1.ID_CODE -- 证件号码
    ,' ' -- 证件名称
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.id_type END -- 证件类型代码
    ,' ' -- 开户用户编号
    ,P1.REG_SUBBRCH_CODE -- 开户机构编号
    ,${iml_schema}.dateformat_min(null) -- 开户日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'fsms_com_cust_info' -- 源表名称
    ,'fsmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.fsms_com_cust_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.cust_type= R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'FSMS'
        AND R1.SRC_TAB_EN_NAME= 'FSMS_COM_CUST_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'cust_type'
        AND R1.TARGET_TAB_EN_NAME= 'PTY_CUST'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.id_type= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'FSMS'
        AND R2.SRC_TAB_EN_NAME= 'FSMS_COM_CUST_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'id_type'
        AND R2.TARGET_TAB_EN_NAME= 'PTY_CUST'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CERT_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.pty_cust_fsmsf1_tm 
  	                                group by 
  	                                        lp_id
  	                                        ,sorc_sys_cd
  	                                        ,cust_id
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
insert /*+ append */ into ${iml_schema}.pty_cust_fsmsf1_ex(
    party_id -- 当事人编号
    ,lp_id -- 法人编号
    ,sorc_sys_cd -- 源系统代码
    ,cust_id -- 客户编号
    ,cust_cate_cd -- 客户类别代码
    ,cust_type_cd -- 客户类型代码
    ,cert_no -- 证件号码
    ,cert_name -- 证件名称
    ,cert_type_cd -- 证件类型代码
    ,open_acct_user_id -- 开户用户编号
    ,open_acct_org_id -- 开户机构编号
    ,open_acct_dt -- 开户日期
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
    ,nvl(n.sorc_sys_cd, o.sorc_sys_cd) as sorc_sys_cd -- 源系统代码
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_cate_cd, o.cust_cate_cd) as cust_cate_cd -- 客户类别代码
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_name, o.cert_name) as cert_name -- 证件名称
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.open_acct_user_id, o.open_acct_user_id) as open_acct_user_id -- 开户用户编号
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.lp_id is null
                and o.sorc_sys_cd is null
                and o.cust_id is null
            ) or (
                o.party_id <> n.party_id
                or o.cust_cate_cd <> n.cust_cate_cd
                or o.cust_type_cd <> n.cust_type_cd
                or o.cert_no <> n.cert_no
                or o.cert_name <> n.cert_name
                or o.cert_type_cd <> n.cert_type_cd
                or o.open_acct_user_id <> n.open_acct_user_id
                or o.open_acct_org_id <> n.open_acct_org_id
                or o.open_acct_dt <> n.open_acct_dt
            ) or (
                 case when (
                           n.lp_id is null
                           and n.sorc_sys_cd is null
                           and n.cust_id is null
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
                n.lp_id is null
                and n.sorc_sys_cd is null
                and n.cust_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.pty_cust_fsmsf1_tm n
    full join ${iml_schema}.pty_cust_fsmsf1_bk o
        on
            o.lp_id = n.lp_id
            and o.sorc_sys_cd = n.sorc_sys_cd
            and o.cust_id = n.cust_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.pty_cust truncate partition for ('fsmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.pty_cust exchange subpartition p_fsmsf1_${batch_date} with table ${iml_schema}.pty_cust_fsmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.pty_cust drop subpartition p_fsmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.pty_cust to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.pty_cust_fsmsf1_tm purge;
drop table ${iml_schema}.pty_cust_fsmsf1_ex purge;
drop table ${iml_schema}.pty_cust_fsmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'pty_cust', partname => 'p_fsmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);