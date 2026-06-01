/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_cust_wrtoff_tran_ncbsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.evt_cust_wrtoff_tran add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_cust_wrtoff_tran partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_tm purge;
drop table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_op purge;
drop table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,wrtoff_seq_num -- 销账序号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,on_acct_bal -- 挂账余额
    ,tran_ref_no -- 交易参考号
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,wrtoff_amt -- 销账金额
    ,cap_src_cd -- 资金来源代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cust_wrtoff_tran partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_cust_wrtoff_tran partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_cust_wrtoff_tran partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_rb_gl_write_off_account-1
insert into ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,wrtoff_seq_num -- 销账序号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,on_acct_bal -- 挂账余额
    ,tran_ref_no -- 交易参考号
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,wrtoff_amt -- 销账金额
    ,cap_src_cd -- 资金来源代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401039'||P1.CLIENT_NO -- 事件编号
    ,'9999' -- 法人编号
    ,P1.WRITE_OFF_SEQ_NO -- 销账序号
    ,P1.HANG_SEQ_NO -- 挂账序号
    ,P1.SUB_HANG_SEQ_NO -- 挂账子账号
    ,P1.BASE_ACCT_NO -- 客户账号
    ,P1.CLIENT_NO -- 客户编号
    ,nvl(trim(P1.CCY),'-') -- 币种代码
    ,P1.HANG_BAL -- 挂账余额
    ,P1.REFERENCE -- 交易参考号
    ,nvl(trim(P1.TRAN_TYPE),'-') -- 交易类型代码
    ,iml.dateformat_max2(to_char(P1.TRAN_DATE,'yyyymmdd')||P1.HANG_WRITE_OFF_TIME) -- 交易日期
    ,${iml_schema}.timeformat_max(P1.TRAN_TIMESTAMP) -- 交易时间
    ,nvl(trim(P1.WRITE_OFF_STATUS),'-') -- 交易状态代码
    ,P1.WRITE_OFF_AMT -- 销账金额
    ,nvl(trim(P1.HANG_DEAL_TYPE),'-') -- 资金来源代码
    ,P1.OTH_ACCT_NAME -- 交易对手账户名称
    ,P1.OTH_BASE_ACCT_NO -- 交易对手账户编号
    ,P1.OTH_BRANCH -- 交易对手开户机构编号
    ,P1.USER_ID -- 交易柜员编号
    ,P1.TRAN_BRANCH -- 交易机构编号
    ,P1.NARRATIVE -- 交易摘要描述
    ,P1.AUTH_USER_ID -- 授权柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_rb_gl_write_off_account' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_rb_gl_write_off_account p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_tm 
  	                                group by 
  	                                        evt_id
  	                                        ,lp_id
  	                                        ,wrtoff_seq_num
  	                                        ,on_acct_seq_num
  	                                        ,on_acct_sub_acct_num
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,wrtoff_seq_num -- 销账序号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,on_acct_bal -- 挂账余额
    ,tran_ref_no -- 交易参考号
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,wrtoff_amt -- 销账金额
    ,cap_src_cd -- 资金来源代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,wrtoff_seq_num -- 销账序号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,on_acct_bal -- 挂账余额
    ,tran_ref_no -- 交易参考号
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,wrtoff_amt -- 销账金额
    ,cap_src_cd -- 资金来源代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.evt_id, o.evt_id) as evt_id -- 事件编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.wrtoff_seq_num, o.wrtoff_seq_num) as wrtoff_seq_num -- 销账序号
    ,nvl(n.on_acct_seq_num, o.on_acct_seq_num) as on_acct_seq_num -- 挂账序号
    ,nvl(n.on_acct_sub_acct_num, o.on_acct_sub_acct_num) as on_acct_sub_acct_num -- 挂账子账号
    ,nvl(n.cust_acct_num, o.cust_acct_num) as cust_acct_num -- 客户账号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.on_acct_bal, o.on_acct_bal) as on_acct_bal -- 挂账余额
    ,nvl(n.tran_ref_no, o.tran_ref_no) as tran_ref_no -- 交易参考号
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_tm, o.tran_tm) as tran_tm -- 交易时间
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.wrtoff_amt, o.wrtoff_amt) as wrtoff_amt -- 销账金额
    ,nvl(n.cap_src_cd, o.cap_src_cd) as cap_src_cd -- 资金来源代码
    ,nvl(n.cntpty_acct_name, o.cntpty_acct_name) as cntpty_acct_name -- 交易对手账户名称
    ,nvl(n.cntpty_acct_id, o.cntpty_acct_id) as cntpty_acct_id -- 交易对手账户编号
    ,nvl(n.cntpty_open_acct_org_id, o.cntpty_open_acct_org_id) as cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,nvl(n.tran_teller_id, o.tran_teller_id) as tran_teller_id -- 交易柜员编号
    ,nvl(n.tran_org_id, o.tran_org_id) as tran_org_id -- 交易机构编号
    ,nvl(n.tran_memo_descb, o.tran_memo_descb) as tran_memo_descb -- 交易摘要描述
    ,nvl(n.auth_teller_id, o.auth_teller_id) as auth_teller_id -- 授权柜员编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.wrtoff_seq_num is null
            and n.on_acct_seq_num is null
            and n.on_acct_sub_acct_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.wrtoff_seq_num is null
            and n.on_acct_seq_num is null
            and n.on_acct_sub_acct_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
            and n.wrtoff_seq_num is null
            and n.on_acct_seq_num is null
            and n.on_acct_sub_acct_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_tm n
    full join (select * from ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.wrtoff_seq_num = n.wrtoff_seq_num
            and o.on_acct_seq_num = n.on_acct_seq_num
            and o.on_acct_sub_acct_num = n.on_acct_sub_acct_num
where (
        o.evt_id is null
        and o.lp_id is null
        and o.wrtoff_seq_num is null
        and o.on_acct_seq_num is null
        and o.on_acct_sub_acct_num is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
        and n.wrtoff_seq_num is null
        and n.on_acct_seq_num is null
        and n.on_acct_sub_acct_num is null
    )
    or (
        o.cust_acct_num <> n.cust_acct_num
        or o.cust_id <> n.cust_id
        or o.curr_cd <> n.curr_cd
        or o.on_acct_bal <> n.on_acct_bal
        or o.tran_ref_no <> n.tran_ref_no
        or o.tran_type_cd <> n.tran_type_cd
        or o.tran_dt <> n.tran_dt
        or o.tran_tm <> n.tran_tm
        or o.tran_status_cd <> n.tran_status_cd
        or o.wrtoff_amt <> n.wrtoff_amt
        or o.cap_src_cd <> n.cap_src_cd
        or o.cntpty_acct_name <> n.cntpty_acct_name
        or o.cntpty_acct_id <> n.cntpty_acct_id
        or o.cntpty_open_acct_org_id <> n.cntpty_open_acct_org_id
        or o.tran_teller_id <> n.tran_teller_id
        or o.tran_org_id <> n.tran_org_id
        or o.tran_memo_descb <> n.tran_memo_descb
        or o.auth_teller_id <> n.auth_teller_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,wrtoff_seq_num -- 销账序号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,on_acct_bal -- 挂账余额
    ,tran_ref_no -- 交易参考号
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,wrtoff_amt -- 销账金额
    ,cap_src_cd -- 资金来源代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,wrtoff_seq_num -- 销账序号
    ,on_acct_seq_num -- 挂账序号
    ,on_acct_sub_acct_num -- 挂账子账号
    ,cust_acct_num -- 客户账号
    ,cust_id -- 客户编号
    ,curr_cd -- 币种代码
    ,on_acct_bal -- 挂账余额
    ,tran_ref_no -- 交易参考号
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,tran_status_cd -- 交易状态代码
    ,wrtoff_amt -- 销账金额
    ,cap_src_cd -- 资金来源代码
    ,cntpty_acct_name -- 交易对手账户名称
    ,cntpty_acct_id -- 交易对手账户编号
    ,cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_memo_descb -- 交易摘要描述
    ,auth_teller_id -- 授权柜员编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.evt_id -- 事件编号
    ,o.lp_id -- 法人编号
    ,o.wrtoff_seq_num -- 销账序号
    ,o.on_acct_seq_num -- 挂账序号
    ,o.on_acct_sub_acct_num -- 挂账子账号
    ,o.cust_acct_num -- 客户账号
    ,o.cust_id -- 客户编号
    ,o.curr_cd -- 币种代码
    ,o.on_acct_bal -- 挂账余额
    ,o.tran_ref_no -- 交易参考号
    ,o.tran_type_cd -- 交易类型代码
    ,o.tran_dt -- 交易日期
    ,o.tran_tm -- 交易时间
    ,o.tran_status_cd -- 交易状态代码
    ,o.wrtoff_amt -- 销账金额
    ,o.cap_src_cd -- 资金来源代码
    ,o.cntpty_acct_name -- 交易对手账户名称
    ,o.cntpty_acct_id -- 交易对手账户编号
    ,o.cntpty_open_acct_org_id -- 交易对手开户机构编号
    ,o.tran_teller_id -- 交易柜员编号
    ,o.tran_org_id -- 交易机构编号
    ,o.tran_memo_descb -- 交易摘要描述
    ,o.auth_teller_id -- 授权柜员编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_bk o
    left join ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.wrtoff_seq_num = n.wrtoff_seq_num
            and o.on_acct_seq_num = n.on_acct_seq_num
            and o.on_acct_sub_acct_num = n.on_acct_sub_acct_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
            and o.wrtoff_seq_num = d.wrtoff_seq_num
            and o.on_acct_seq_num = d.on_acct_seq_num
            and o.on_acct_sub_acct_num = d.on_acct_sub_acct_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_cust_wrtoff_tran;
--alter table ${iml_schema}.evt_cust_wrtoff_tran truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_cust_wrtoff_tran') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_cust_wrtoff_tran drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.evt_cust_wrtoff_tran modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_cust_wrtoff_tran exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_cl;
alter table ${iml_schema}.evt_cust_wrtoff_tran exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_cust_wrtoff_tran to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_tm purge;
drop table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_op purge;
drop table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_cust_wrtoff_tran_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_cust_wrtoff_tran', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
