/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bcdl_acct_sign_info_mpcsf1
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
drop table ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_tm purge;
drop table ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bcdl_acct_sign_info add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bcdl_acct_sign_info modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bcdl_acct_sign_info partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_id -- 签约编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,acct_prvlg_cd -- 账户权限代码
    ,open_acct_org_id -- 开户机构编号
    ,acct_sign_status_cd -- 账户签约状态代码
    ,sign_dt -- 签约日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bcdl_acct_sign_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bcdl_acct_sign_info partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a63tacct-
insert into ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_id -- 签约编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,acct_prvlg_cd -- 账户权限代码
    ,open_acct_org_id -- 开户机构编号
    ,acct_sign_status_cd -- 账户签约状态代码
    ,sign_dt -- 签约日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '221016'||P1.SIGNNO||ACCTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SIGNNO -- 签约编号
    ,P1.ACCTNO -- 账户编号
    ,P1.ACCTNAME -- 账户名称
    ,P1.CUSTNO -- 客户编号
    ,nvl(trim(P1.PERMIT),'-') -- 账户权限代码
    ,P1.OPENBRCNO -- 开户机构编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STAT END -- 账户签约状态代码
    ,${iml_schema}.dateformat_min(P1.SIGNDT) -- 签约日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a63tacct' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a63tacct p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STAT = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A63TACCT'
        AND R2.SRC_FIELD_EN_NAME= 'STAT'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BCDL_ACCT_SIGN_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ACCT_SIGN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_tm 
  	                                group by 
  	                                        agt_id
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
insert /*+ append */ into ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,sign_id -- 签约编号
    ,acct_id -- 账户编号
    ,acct_name -- 账户名称
    ,cust_id -- 客户编号
    ,acct_prvlg_cd -- 账户权限代码
    ,open_acct_org_id -- 开户机构编号
    ,acct_sign_status_cd -- 账户签约状态代码
    ,sign_dt -- 签约日期
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.sign_id, o.sign_id) as sign_id -- 签约编号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.acct_prvlg_cd, o.acct_prvlg_cd) as acct_prvlg_cd -- 账户权限代码
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.acct_sign_status_cd, o.acct_sign_status_cd) as acct_sign_status_cd -- 账户签约状态代码
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.sign_id <> n.sign_id
                or o.acct_id <> n.acct_id
                or o.acct_name <> n.acct_name
                or o.cust_id <> n.cust_id
                or o.acct_prvlg_cd <> n.acct_prvlg_cd
                or o.open_acct_org_id <> n.open_acct_org_id
                or o.acct_sign_status_cd <> n.acct_sign_status_cd
                or o.sign_dt <> n.sign_dt
            ) or (
                 case when (
                           n.agt_id is null
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
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_tm n
    full join ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bcdl_acct_sign_info truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bcdl_acct_sign_info exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bcdl_acct_sign_info drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bcdl_acct_sign_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_tm purge;
drop table ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_ex purge;
drop table ${iml_schema}.agt_bcdl_acct_sign_info_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bcdl_acct_sign_info', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);