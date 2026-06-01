/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_bus_stl_info_bdmsf1
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
alter table ${iml_schema}.agt_bill_bus_stl_info add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_bus_stl_info partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    bus_stl_id -- 业务结算编号
    ,lp_id -- 法人编号
    ,mem_org_cd -- 会员机构代码
    ,stl_req_id -- 结算请求编号
    ,stl_tm -- 结算时间
    ,bus_type_cd -- 业务类型代码
    ,stl_way_cd -- 结算方式代码
    ,stl_bus_type_cd -- 结算业务类型代码
    ,clear_type_cd -- 清算类型代码
    ,bag_dir_cd -- 成交方向代码
    ,stl_amt -- 结算金额
    ,int_paybl -- 应付利息
    ,bill_cnt -- 票据张数
    ,ctr_nt_id -- 成交单编号
    ,lg_pay_sys_msg_ind_no -- 大额支付系统报文标识号
    ,bill_num -- 票据号码
    ,recver_org_cd -- 收款方机构代码
    ,recver_trust_acct_num -- 收款方托管账号
    ,recver_trust_acct_name -- 收款方托管账户名称
    ,recver_cap_acct_num -- 收款方资金账号
    ,recver_cap_acct_name -- 收款方资金账户名称
    ,payer_org_cd -- 付款方机构代码
    ,payer_trust_acct_num -- 付款方托管账号
    ,payer_trust_acct_name -- 付款方托管账户名称
    ,payer_cap_acct_num -- 付款方资金账号
    ,payer_cap_acct_name -- 付款方资金账户名称
    ,stl_status_cd -- 结算状态代码
    ,stl_rest_code -- 结算结果编码
    ,stl_fail_rs -- 结算失败原因
    ,bill_sub_intrv_id -- 票据子区间编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_bus_stl_info partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_bus_stl_info partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_bus_stl_info partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_cas_settle_info-
insert into ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_tm(
    bus_stl_id -- 业务结算编号
    ,lp_id -- 法人编号
    ,mem_org_cd -- 会员机构代码
    ,stl_req_id -- 结算请求编号
    ,stl_tm -- 结算时间
    ,bus_type_cd -- 业务类型代码
    ,stl_way_cd -- 结算方式代码
    ,stl_bus_type_cd -- 结算业务类型代码
    ,clear_type_cd -- 清算类型代码
    ,bag_dir_cd -- 成交方向代码
    ,stl_amt -- 结算金额
    ,int_paybl -- 应付利息
    ,bill_cnt -- 票据张数
    ,ctr_nt_id -- 成交单编号
    ,lg_pay_sys_msg_ind_no -- 大额支付系统报文标识号
    ,bill_num -- 票据号码
    ,recver_org_cd -- 收款方机构代码
    ,recver_trust_acct_num -- 收款方托管账号
    ,recver_trust_acct_name -- 收款方托管账户名称
    ,recver_cap_acct_num -- 收款方资金账号
    ,recver_cap_acct_name -- 收款方资金账户名称
    ,payer_org_cd -- 付款方机构代码
    ,payer_trust_acct_num -- 付款方托管账号
    ,payer_trust_acct_name -- 付款方托管账户名称
    ,payer_cap_acct_num -- 付款方资金账号
    ,payer_cap_acct_name -- 付款方资金账户名称
    ,stl_status_cd -- 结算状态代码
    ,stl_rest_code -- 结算结果编码
    ,stl_fail_rs -- 结算失败原因
    ,bill_sub_intrv_id -- 票据子区间编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 业务结算编号
    ,'9999' -- 法人编号
    ,P1.BRH_NO -- 会员机构代码
    ,P1.SETTLE_REQ_NO -- 结算请求编号
    ,${iml_schema}.DATEFORMAT_MAX(P1.SETTLE_TM) -- 结算时间
    ,nvl(trim(P1.BUSS_TYPE),'-') -- 业务类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.SETTLE_TYPE END -- 结算方式代码
    ,NVL(TRIM(P1.SETTLE_REQ_TYPE),'-') -- 结算业务类型代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CLEAR_TYPE END -- 清算类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRADE_DIRECT END -- 成交方向代码
    ,P1.SETTLE_AMT -- 结算金额
    ,P1.PAY_INTEREST -- 应付利息
    ,P1.DRAFT_COUNT -- 票据张数
    ,P1.DEAL_NO -- 成交单编号
    ,P1.CCPC_MSG_ID -- 大额支付系统报文标识号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,P1.RCV_BRH_NO -- 收款方机构代码
    ,P1.RCV_TACCT_NO -- 收款方托管账号
    ,P1.RCV_TACCT_NAME -- 收款方托管账户名称
    ,P1.RCV_FACCT_NO -- 收款方资金账号
    ,P1.RCV_FACCT_NAME -- 收款方资金账户名称
    ,P1.PAY_BRH_NO -- 付款方机构代码
    ,P1.PAY_TACCT_NO -- 付款方托管账号
    ,P1.PAY_TACCT_NAME -- 付款方托管账户名称
    ,P1.PAY_FACCT_NO -- 付款方资金账号
    ,P1.PAY_FACCT_NAME -- 付款方资金账户名称
    ,NVL(TRIM(P1.SETTLE_STATUS),'-') -- 结算状态代码
    ,P1.SETTLE_RESULT -- 结算结果编码
    ,P1.SETTLE_FRSN -- 结算失败原因
    ,P1.CD_RANGE -- 票据子区间编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cas_settle_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cas_settle_info p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.SETTLE_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CAS_SETTLE_INFO'
        AND R1.SRC_FIELD_EN_NAME= 'SETTLE_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_BUS_STL_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'STL_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CLEAR_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CAS_SETTLE_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'CLEAR_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_BUS_STL_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRADE_DIRECT= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CAS_SETTLE_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'TRADE_DIRECT'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BILL_BUS_STL_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BAG_DIR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_tm 
  	                                group by 
  	                                        bus_stl_id
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_cl(
            bus_stl_id -- 业务结算编号
    ,lp_id -- 法人编号
    ,mem_org_cd -- 会员机构代码
    ,stl_req_id -- 结算请求编号
    ,stl_tm -- 结算时间
    ,bus_type_cd -- 业务类型代码
    ,stl_way_cd -- 结算方式代码
    ,stl_bus_type_cd -- 结算业务类型代码
    ,clear_type_cd -- 清算类型代码
    ,bag_dir_cd -- 成交方向代码
    ,stl_amt -- 结算金额
    ,int_paybl -- 应付利息
    ,bill_cnt -- 票据张数
    ,ctr_nt_id -- 成交单编号
    ,lg_pay_sys_msg_ind_no -- 大额支付系统报文标识号
    ,bill_num -- 票据号码
    ,recver_org_cd -- 收款方机构代码
    ,recver_trust_acct_num -- 收款方托管账号
    ,recver_trust_acct_name -- 收款方托管账户名称
    ,recver_cap_acct_num -- 收款方资金账号
    ,recver_cap_acct_name -- 收款方资金账户名称
    ,payer_org_cd -- 付款方机构代码
    ,payer_trust_acct_num -- 付款方托管账号
    ,payer_trust_acct_name -- 付款方托管账户名称
    ,payer_cap_acct_num -- 付款方资金账号
    ,payer_cap_acct_name -- 付款方资金账户名称
    ,stl_status_cd -- 结算状态代码
    ,stl_rest_code -- 结算结果编码
    ,stl_fail_rs -- 结算失败原因
    ,bill_sub_intrv_id -- 票据子区间编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_op(
            bus_stl_id -- 业务结算编号
    ,lp_id -- 法人编号
    ,mem_org_cd -- 会员机构代码
    ,stl_req_id -- 结算请求编号
    ,stl_tm -- 结算时间
    ,bus_type_cd -- 业务类型代码
    ,stl_way_cd -- 结算方式代码
    ,stl_bus_type_cd -- 结算业务类型代码
    ,clear_type_cd -- 清算类型代码
    ,bag_dir_cd -- 成交方向代码
    ,stl_amt -- 结算金额
    ,int_paybl -- 应付利息
    ,bill_cnt -- 票据张数
    ,ctr_nt_id -- 成交单编号
    ,lg_pay_sys_msg_ind_no -- 大额支付系统报文标识号
    ,bill_num -- 票据号码
    ,recver_org_cd -- 收款方机构代码
    ,recver_trust_acct_num -- 收款方托管账号
    ,recver_trust_acct_name -- 收款方托管账户名称
    ,recver_cap_acct_num -- 收款方资金账号
    ,recver_cap_acct_name -- 收款方资金账户名称
    ,payer_org_cd -- 付款方机构代码
    ,payer_trust_acct_num -- 付款方托管账号
    ,payer_trust_acct_name -- 付款方托管账户名称
    ,payer_cap_acct_num -- 付款方资金账号
    ,payer_cap_acct_name -- 付款方资金账户名称
    ,stl_status_cd -- 结算状态代码
    ,stl_rest_code -- 结算结果编码
    ,stl_fail_rs -- 结算失败原因
    ,bill_sub_intrv_id -- 票据子区间编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bus_stl_id, o.bus_stl_id) as bus_stl_id -- 业务结算编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.mem_org_cd, o.mem_org_cd) as mem_org_cd -- 会员机构代码
    ,nvl(n.stl_req_id, o.stl_req_id) as stl_req_id -- 结算请求编号
    ,nvl(n.stl_tm, o.stl_tm) as stl_tm -- 结算时间
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.stl_way_cd, o.stl_way_cd) as stl_way_cd -- 结算方式代码
    ,nvl(n.stl_bus_type_cd, o.stl_bus_type_cd) as stl_bus_type_cd -- 结算业务类型代码
    ,nvl(n.clear_type_cd, o.clear_type_cd) as clear_type_cd -- 清算类型代码
    ,nvl(n.bag_dir_cd, o.bag_dir_cd) as bag_dir_cd -- 成交方向代码
    ,nvl(n.stl_amt, o.stl_amt) as stl_amt -- 结算金额
    ,nvl(n.int_paybl, o.int_paybl) as int_paybl -- 应付利息
    ,nvl(n.bill_cnt, o.bill_cnt) as bill_cnt -- 票据张数
    ,nvl(n.ctr_nt_id, o.ctr_nt_id) as ctr_nt_id -- 成交单编号
    ,nvl(n.lg_pay_sys_msg_ind_no, o.lg_pay_sys_msg_ind_no) as lg_pay_sys_msg_ind_no -- 大额支付系统报文标识号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.recver_org_cd, o.recver_org_cd) as recver_org_cd -- 收款方机构代码
    ,nvl(n.recver_trust_acct_num, o.recver_trust_acct_num) as recver_trust_acct_num -- 收款方托管账号
    ,nvl(n.recver_trust_acct_name, o.recver_trust_acct_name) as recver_trust_acct_name -- 收款方托管账户名称
    ,nvl(n.recver_cap_acct_num, o.recver_cap_acct_num) as recver_cap_acct_num -- 收款方资金账号
    ,nvl(n.recver_cap_acct_name, o.recver_cap_acct_name) as recver_cap_acct_name -- 收款方资金账户名称
    ,nvl(n.payer_org_cd, o.payer_org_cd) as payer_org_cd -- 付款方机构代码
    ,nvl(n.payer_trust_acct_num, o.payer_trust_acct_num) as payer_trust_acct_num -- 付款方托管账号
    ,nvl(n.payer_trust_acct_name, o.payer_trust_acct_name) as payer_trust_acct_name -- 付款方托管账户名称
    ,nvl(n.payer_cap_acct_num, o.payer_cap_acct_num) as payer_cap_acct_num -- 付款方资金账号
    ,nvl(n.payer_cap_acct_name, o.payer_cap_acct_name) as payer_cap_acct_name -- 付款方资金账户名称
    ,nvl(n.stl_status_cd, o.stl_status_cd) as stl_status_cd -- 结算状态代码
    ,nvl(n.stl_rest_code, o.stl_rest_code) as stl_rest_code -- 结算结果编码
    ,nvl(n.stl_fail_rs, o.stl_fail_rs) as stl_fail_rs -- 结算失败原因
    ,nvl(n.bill_sub_intrv_id, o.bill_sub_intrv_id) as bill_sub_intrv_id -- 票据子区间编号
    ,case when
            n.bus_stl_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bus_stl_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bus_stl_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_tm n
    full join (select * from ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.bus_stl_id = n.bus_stl_id
            and o.lp_id = n.lp_id
where (
        o.bus_stl_id is null
        and o.lp_id is null
    )
    or (
        n.bus_stl_id is null
        and n.lp_id is null
    )
    or (
        o.mem_org_cd <> n.mem_org_cd
        or o.stl_req_id <> n.stl_req_id
        or o.stl_tm <> n.stl_tm
        or o.bus_type_cd <> n.bus_type_cd
        or o.stl_way_cd <> n.stl_way_cd
        or o.stl_bus_type_cd <> n.stl_bus_type_cd
        or o.clear_type_cd <> n.clear_type_cd
        or o.bag_dir_cd <> n.bag_dir_cd
        or o.stl_amt <> n.stl_amt
        or o.int_paybl <> n.int_paybl
        or o.bill_cnt <> n.bill_cnt
        or o.ctr_nt_id <> n.ctr_nt_id
        or o.lg_pay_sys_msg_ind_no <> n.lg_pay_sys_msg_ind_no
        or o.bill_num <> n.bill_num
        or o.recver_org_cd <> n.recver_org_cd
        or o.recver_trust_acct_num <> n.recver_trust_acct_num
        or o.recver_trust_acct_name <> n.recver_trust_acct_name
        or o.recver_cap_acct_num <> n.recver_cap_acct_num
        or o.recver_cap_acct_name <> n.recver_cap_acct_name
        or o.payer_org_cd <> n.payer_org_cd
        or o.payer_trust_acct_num <> n.payer_trust_acct_num
        or o.payer_trust_acct_name <> n.payer_trust_acct_name
        or o.payer_cap_acct_num <> n.payer_cap_acct_num
        or o.payer_cap_acct_name <> n.payer_cap_acct_name
        or o.stl_status_cd <> n.stl_status_cd
        or o.stl_rest_code <> n.stl_rest_code
        or o.stl_fail_rs <> n.stl_fail_rs
        or o.bill_sub_intrv_id <> n.bill_sub_intrv_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_cl(
            bus_stl_id -- 业务结算编号
    ,lp_id -- 法人编号
    ,mem_org_cd -- 会员机构代码
    ,stl_req_id -- 结算请求编号
    ,stl_tm -- 结算时间
    ,bus_type_cd -- 业务类型代码
    ,stl_way_cd -- 结算方式代码
    ,stl_bus_type_cd -- 结算业务类型代码
    ,clear_type_cd -- 清算类型代码
    ,bag_dir_cd -- 成交方向代码
    ,stl_amt -- 结算金额
    ,int_paybl -- 应付利息
    ,bill_cnt -- 票据张数
    ,ctr_nt_id -- 成交单编号
    ,lg_pay_sys_msg_ind_no -- 大额支付系统报文标识号
    ,bill_num -- 票据号码
    ,recver_org_cd -- 收款方机构代码
    ,recver_trust_acct_num -- 收款方托管账号
    ,recver_trust_acct_name -- 收款方托管账户名称
    ,recver_cap_acct_num -- 收款方资金账号
    ,recver_cap_acct_name -- 收款方资金账户名称
    ,payer_org_cd -- 付款方机构代码
    ,payer_trust_acct_num -- 付款方托管账号
    ,payer_trust_acct_name -- 付款方托管账户名称
    ,payer_cap_acct_num -- 付款方资金账号
    ,payer_cap_acct_name -- 付款方资金账户名称
    ,stl_status_cd -- 结算状态代码
    ,stl_rest_code -- 结算结果编码
    ,stl_fail_rs -- 结算失败原因
    ,bill_sub_intrv_id -- 票据子区间编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_op(
            bus_stl_id -- 业务结算编号
    ,lp_id -- 法人编号
    ,mem_org_cd -- 会员机构代码
    ,stl_req_id -- 结算请求编号
    ,stl_tm -- 结算时间
    ,bus_type_cd -- 业务类型代码
    ,stl_way_cd -- 结算方式代码
    ,stl_bus_type_cd -- 结算业务类型代码
    ,clear_type_cd -- 清算类型代码
    ,bag_dir_cd -- 成交方向代码
    ,stl_amt -- 结算金额
    ,int_paybl -- 应付利息
    ,bill_cnt -- 票据张数
    ,ctr_nt_id -- 成交单编号
    ,lg_pay_sys_msg_ind_no -- 大额支付系统报文标识号
    ,bill_num -- 票据号码
    ,recver_org_cd -- 收款方机构代码
    ,recver_trust_acct_num -- 收款方托管账号
    ,recver_trust_acct_name -- 收款方托管账户名称
    ,recver_cap_acct_num -- 收款方资金账号
    ,recver_cap_acct_name -- 收款方资金账户名称
    ,payer_org_cd -- 付款方机构代码
    ,payer_trust_acct_num -- 付款方托管账号
    ,payer_trust_acct_name -- 付款方托管账户名称
    ,payer_cap_acct_num -- 付款方资金账号
    ,payer_cap_acct_name -- 付款方资金账户名称
    ,stl_status_cd -- 结算状态代码
    ,stl_rest_code -- 结算结果编码
    ,stl_fail_rs -- 结算失败原因
    ,bill_sub_intrv_id -- 票据子区间编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bus_stl_id -- 业务结算编号
    ,o.lp_id -- 法人编号
    ,o.mem_org_cd -- 会员机构代码
    ,o.stl_req_id -- 结算请求编号
    ,o.stl_tm -- 结算时间
    ,o.bus_type_cd -- 业务类型代码
    ,o.stl_way_cd -- 结算方式代码
    ,o.stl_bus_type_cd -- 结算业务类型代码
    ,o.clear_type_cd -- 清算类型代码
    ,o.bag_dir_cd -- 成交方向代码
    ,o.stl_amt -- 结算金额
    ,o.int_paybl -- 应付利息
    ,o.bill_cnt -- 票据张数
    ,o.ctr_nt_id -- 成交单编号
    ,o.lg_pay_sys_msg_ind_no -- 大额支付系统报文标识号
    ,o.bill_num -- 票据号码
    ,o.recver_org_cd -- 收款方机构代码
    ,o.recver_trust_acct_num -- 收款方托管账号
    ,o.recver_trust_acct_name -- 收款方托管账户名称
    ,o.recver_cap_acct_num -- 收款方资金账号
    ,o.recver_cap_acct_name -- 收款方资金账户名称
    ,o.payer_org_cd -- 付款方机构代码
    ,o.payer_trust_acct_num -- 付款方托管账号
    ,o.payer_trust_acct_name -- 付款方托管账户名称
    ,o.payer_cap_acct_num -- 付款方资金账号
    ,o.payer_cap_acct_name -- 付款方资金账户名称
    ,o.stl_status_cd -- 结算状态代码
    ,o.stl_rest_code -- 结算结果编码
    ,o.stl_fail_rs -- 结算失败原因
    ,o.bill_sub_intrv_id -- 票据子区间编号
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
from ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_bk o
    left join ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_op n
        on
            o.bus_stl_id = n.bus_stl_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_cl d
        on
            o.bus_stl_id = d.bus_stl_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_bill_bus_stl_info;
--alter table ${iml_schema}.agt_bill_bus_stl_info truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_bill_bus_stl_info') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_bill_bus_stl_info drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_bill_bus_stl_info modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_bill_bus_stl_info exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_cl;
alter table ${iml_schema}.agt_bill_bus_stl_info exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_bus_stl_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_op purge;
drop table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_bill_bus_stl_info_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_bus_stl_info', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
