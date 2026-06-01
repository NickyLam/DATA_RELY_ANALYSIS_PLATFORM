/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_finc_sign_acct_info_ifmsf1
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
drop table ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_finc_sign_acct_info add partition p_ifmsf1 values ('ifmsf1')(
        subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_finc_sign_acct_info modify partition p_ifmsf1
    add subpartition p_ifmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_finc_sign_acct_info partition for ('ifmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bank_cd -- 银行代码
    ,bank_acct_num -- 银行账号
    ,ta_tran_acct_id -- TA交易账户编号
    ,intnal_cust_id -- 内部客户编号
    ,cust_type_cd -- 客户类型代码
    ,acct_org_id -- 账户机构编号
    ,acct_sign_status_cd -- 账户签约状态代码
    ,sign_dt -- 签约日期
    ,rels_dt -- 解约日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_finc_sign_acct_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_finc_sign_acct_info partition for ('ifmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ifms_tbbankacc-1
insert into ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bank_cd -- 银行代码
    ,bank_acct_num -- 银行账号
    ,ta_tran_acct_id -- TA交易账户编号
    ,intnal_cust_id -- 内部客户编号
    ,cust_type_cd -- 客户类型代码
    ,acct_org_id -- 账户机构编号
    ,acct_sign_status_cd -- 账户签约状态代码
    ,sign_dt -- 签约日期
    ,rels_dt -- 解约日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '130025'||P1.BANK_NO||P1.BANK_ACC -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BANK_NO -- 银行代码
    ,NVL(P2.BANK_ACC, P1.BANK_ACC) -- 银行账号
    ,P1.TA_CLIENT -- TA交易账户编号
    ,P1.IN_CLIENT_NO -- 内部客户编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,P1.OPEN_BRANCH -- 账户机构编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STATUS END -- 账户签约状态代码
    ,${iml_schema}.DATEFORMAT_min(P1.TRANS_DATE) -- 签约日期
    ,${iml_schema}.DATEFORMAT_max(P1.SIGNOFF_DATE) -- 解约日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ifms_tbbankacc' -- 源表名称
    ,'ifmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ifms_tbbankacc p1
left join ${iol_schema}.ifms_tbvirbankaccmap p2 on p1.bank_acc = p2.vir_bank_acc and p2.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p2.end_dt > to_date('${batch_date}', 'yyyymmdd')
left join ${iml_schema}.ref_pub_cd_map r1 on p1.client_type = r1.src_code_val
 and r1.sorc_sys_cd = 'IFMS'
 and r1.src_tab_en_name = 'IFMS_TBBANKACC'
 and r1.src_field_en_name = 'CLIENT_TYPE'
 and r1.target_tab_en_name = 'AGT_FINC_SIGN_ACCT_INFO'
 and r1.target_tab_field_en_name = 'CUST_TYPE_CD'
left join ${iml_schema}.ref_pub_cd_map r2 on p1.status = r2.src_code_val
 and r2.sorc_sys_cd = 'IFMS'
 and r2.src_tab_en_name = 'IFMS_TBBANKACC'
 and r2.src_field_en_name = 'STATUS'
 and r2.target_tab_en_name = 'AGT_FINC_SIGN_ACCT_INFO'
 and r2.target_tab_field_en_name = 'ACCT_SIGN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}', 'yyyymmdd') and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
  ;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,bank_cd -- 银行代码
    ,bank_acct_num -- 银行账号
    ,ta_tran_acct_id -- TA交易账户编号
    ,intnal_cust_id -- 内部客户编号
    ,cust_type_cd -- 客户类型代码
    ,acct_org_id -- 账户机构编号
    ,acct_sign_status_cd -- 账户签约状态代码
    ,sign_dt -- 签约日期
    ,rels_dt -- 解约日期
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
    ,nvl(n.bank_cd, o.bank_cd) as bank_cd -- 银行代码
    ,nvl(n.bank_acct_num, o.bank_acct_num) as bank_acct_num -- 银行账号
    ,nvl(n.ta_tran_acct_id, o.ta_tran_acct_id) as ta_tran_acct_id -- TA交易账户编号
    ,nvl(n.intnal_cust_id, o.intnal_cust_id) as intnal_cust_id -- 内部客户编号
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.acct_org_id, o.acct_org_id) as acct_org_id -- 账户机构编号
    ,nvl(n.acct_sign_status_cd, o.acct_sign_status_cd) as acct_sign_status_cd -- 账户签约状态代码
    ,nvl(n.sign_dt, o.sign_dt) as sign_dt -- 签约日期
    ,nvl(n.rels_dt, o.rels_dt) as rels_dt -- 解约日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.bank_cd <> n.bank_cd
                or o.bank_acct_num <> n.bank_acct_num
                or o.ta_tran_acct_id <> n.ta_tran_acct_id
                or o.intnal_cust_id <> n.intnal_cust_id
                or o.cust_type_cd <> n.cust_type_cd
                or o.acct_org_id <> n.acct_org_id
                or o.acct_sign_status_cd <> n.acct_sign_status_cd
                or o.sign_dt <> n.sign_dt
                or o.rels_dt <> n.rels_dt
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
from ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_tm n
    full join ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_finc_sign_acct_info truncate partition for ('ifmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_finc_sign_acct_info exchange subpartition p_ifmsf1_${batch_date} with table ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_finc_sign_acct_info drop subpartition p_ifmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_finc_sign_acct_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_tm purge;
drop table ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_ex purge;
drop table ${iml_schema}.agt_finc_sign_acct_info_ifmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_finc_sign_acct_info', partname => 'p_ifmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);