/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_rgst_cter_bill_ccution_bdmsf1
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
alter table ${iml_schema}.evt_rgst_cter_bill_ccution add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_bdmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_rgst_cter_bill_ccution partition for ('bdmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_tm purge;
drop table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_op purge;
drop table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_tm nologging
compress ${option_switch} for query high
as select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,agt_id -- 协议编号
    ,agt_dtl_id -- 协议明细编号
    ,bill_id -- 票据编号
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bill_num -- 票据号码
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_mem_id -- 请求方会员编号
    ,reqer_org_id -- 请求方机构编号
    ,reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_num -- 接收方账号
    ,recver_mem_code -- 接收方会员编码
    ,recver_org_id -- 接收方机构编号
    ,recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,actl_amt -- 实付金额
    ,actl_int -- 实付利息
    ,int_rat -- 利率
    ,stop_pay_type_cd -- 止付类型代码
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,sys_in_flg -- 系统内标志
    ,tran_status_cd -- 交易状态代码
    ,payoff_type_cd -- 结清类型代码
    ,invtry_org_id -- 库存机构编号
    ,hq_org_id -- 总行机构编号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_rgst_cter_bill_ccution partition for ('bdmsf1')
where 0=1
;

create table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_rgst_cter_bill_ccution partition for ('bdmsf1') where 0=1;

create table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.evt_rgst_cter_bill_ccution partition for ('bdmsf1') where 0=1;

-- 3.1 get new data into table
-- bdms_dpc_draft_trans_info-
insert into ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,agt_id -- 协议编号
    ,agt_dtl_id -- 协议明细编号
    ,bill_id -- 票据编号
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bill_num -- 票据号码
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_mem_id -- 请求方会员编号
    ,reqer_org_id -- 请求方机构编号
    ,reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_num -- 接收方账号
    ,recver_mem_code -- 接收方会员编码
    ,recver_org_id -- 接收方机构编号
    ,recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,actl_amt -- 实付金额
    ,actl_int -- 实付利息
    ,int_rat -- 利率
    ,stop_pay_type_cd -- 止付类型代码
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,sys_in_flg -- 系统内标志
    ,tran_status_cd -- 交易状态代码
    ,payoff_type_cd -- 结清类型代码
    ,invtry_org_id -- 库存机构编号
    ,hq_org_id -- 总行机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '104011'||P1.TXN_DATE||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 登记编号
    ,P1.CONTRACT_ID -- 协议编号
    ,P1.DETAILS_ID -- 协议明细编号
    ,P1.DRAFT_ID -- 票据编号
    ,NVL(TRIM(P1.BUSI_TYPE),'-') -- 业务类型代码
    ,P1.BUSI_ATTR_NO -- 业务属性代码
    ,P1.DRAFT_NUMBER -- 票据号码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRADE_DIRECT END -- 交易方向代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TXN_DATE) -- 交易日期
    ,NVL(TRIM(P1.REQ_TYPE),'0') -- 请求方类型代码
    ,P1.REQ_NAME -- 请求方名称
    ,P1.REQ_CERT_NO -- 请求方社会信用代码
    ,P1.REQ_ACCOUNT -- 请求方账号
    ,P1.REQ_MEM_NO -- 请求方会员编号
    ,P1.REQ_BRH_NO -- 请求方机构编号
    ,P1.REQ_BANK_NO -- 请求方支付系统行行号
    ,NVL(TRIM(P1.RCV_TYPE),'0') -- 接收方类型代码
    ,P1.RCV_NAME -- 接收方名称
    ,P1.RCV_CERT_NO -- 接收方社会信用代码
    ,P1.RCV_ACCOUNT -- 接收方账号
    ,P1.RCV_MEM_NO -- 接收方会员编码
    ,P1.RCV_BRH_NO -- 接收方机构编号
    ,P1.RCV_BANK_NO -- 接收方支付系统行行号
    ,P1.PAY_AMOUNT -- 实付金额
    ,P1.PAY_INTEREST -- 实付利息
    ,P1.RATE -- 利率
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STOP_PAY_TYPE END -- 止付类型代码
    ,NVL(TRIM(P1.RELIEVE_STP_TYPE),'RT00') -- 解除止付类型代码
    ,P1.TENOR_DAYS -- 剩余期限
    ,P1.SETTLE_AMT -- 结算金额
    ,NVL(TRIM(P1.INNER_FLAG),'-') -- 系统内标志
    ,NVL(TRIM(P1.TRANS_STATUS),'-') -- 交易状态代码
    ,NVL(TRIM(P1.SETTLE_TYPE),'-') -- 结清类型代码
    ,P1.STORE_BRH_NO -- 库存机构编号
    ,P1.TOP_BRANCH_NO -- 总行机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_dpc_draft_trans_info' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_dpc_draft_trans_info p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRADE_DIRECT= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_DPC_DRAFT_TRANS_INFO'
        AND R3.SRC_FIELD_EN_NAME= 'TRADE_DIRECT'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_RGST_CTER_BILL_CCUTION'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STOP_PAY_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_DPC_DRAFT_TRANS_INFO'
        AND R2.SRC_FIELD_EN_NAME= 'STOP_PAY_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_RGST_CTER_BILL_CCUTION'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'STOP_PAY_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_tm 
  	                                group by 
  	                                        evt_id
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
        into ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,agt_id -- 协议编号
    ,agt_dtl_id -- 协议明细编号
    ,bill_id -- 票据编号
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bill_num -- 票据号码
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_mem_id -- 请求方会员编号
    ,reqer_org_id -- 请求方机构编号
    ,reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_num -- 接收方账号
    ,recver_mem_code -- 接收方会员编码
    ,recver_org_id -- 接收方机构编号
    ,recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,actl_amt -- 实付金额
    ,actl_int -- 实付利息
    ,int_rat -- 利率
    ,stop_pay_type_cd -- 止付类型代码
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,sys_in_flg -- 系统内标志
    ,tran_status_cd -- 交易状态代码
    ,payoff_type_cd -- 结清类型代码
    ,invtry_org_id -- 库存机构编号
    ,hq_org_id -- 总行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,agt_id -- 协议编号
    ,agt_dtl_id -- 协议明细编号
    ,bill_id -- 票据编号
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bill_num -- 票据号码
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_mem_id -- 请求方会员编号
    ,reqer_org_id -- 请求方机构编号
    ,reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_num -- 接收方账号
    ,recver_mem_code -- 接收方会员编码
    ,recver_org_id -- 接收方机构编号
    ,recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,actl_amt -- 实付金额
    ,actl_int -- 实付利息
    ,int_rat -- 利率
    ,stop_pay_type_cd -- 止付类型代码
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,sys_in_flg -- 系统内标志
    ,tran_status_cd -- 交易状态代码
    ,payoff_type_cd -- 结清类型代码
    ,invtry_org_id -- 库存机构编号
    ,hq_org_id -- 总行机构编号
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
    ,nvl(n.rgst_id, o.rgst_id) as rgst_id -- 登记编号
    ,nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.agt_dtl_id, o.agt_dtl_id) as agt_dtl_id -- 协议明细编号
    ,nvl(n.bill_id, o.bill_id) as bill_id -- 票据编号
    ,nvl(n.bus_type_cd, o.bus_type_cd) as bus_type_cd -- 业务类型代码
    ,nvl(n.bus_attr_cd, o.bus_attr_cd) as bus_attr_cd -- 业务属性代码
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.tran_dir_cd, o.tran_dir_cd) as tran_dir_cd -- 交易方向代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.reqer_type_cd, o.reqer_type_cd) as reqer_type_cd -- 请求方类型代码
    ,nvl(n.reqer_name, o.reqer_name) as reqer_name -- 请求方名称
    ,nvl(n.reqer_soci_crdt_cd, o.reqer_soci_crdt_cd) as reqer_soci_crdt_cd -- 请求方社会信用代码
    ,nvl(n.reqer_acct_num, o.reqer_acct_num) as reqer_acct_num -- 请求方账号
    ,nvl(n.reqer_mem_id, o.reqer_mem_id) as reqer_mem_id -- 请求方会员编号
    ,nvl(n.reqer_org_id, o.reqer_org_id) as reqer_org_id -- 请求方机构编号
    ,nvl(n.reqer_pay_sys_bank_no, o.reqer_pay_sys_bank_no) as reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,nvl(n.recver_type_cd, o.recver_type_cd) as recver_type_cd -- 接收方类型代码
    ,nvl(n.recver_name, o.recver_name) as recver_name -- 接收方名称
    ,nvl(n.recver_soci_crdt_cd, o.recver_soci_crdt_cd) as recver_soci_crdt_cd -- 接收方社会信用代码
    ,nvl(n.recver_acct_num, o.recver_acct_num) as recver_acct_num -- 接收方账号
    ,nvl(n.recver_mem_code, o.recver_mem_code) as recver_mem_code -- 接收方会员编码
    ,nvl(n.recver_org_id, o.recver_org_id) as recver_org_id -- 接收方机构编号
    ,nvl(n.recver_pay_sys_bank_no, o.recver_pay_sys_bank_no) as recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,nvl(n.actl_amt, o.actl_amt) as actl_amt -- 实付金额
    ,nvl(n.actl_int, o.actl_int) as actl_int -- 实付利息
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 利率
    ,nvl(n.stop_pay_type_cd, o.stop_pay_type_cd) as stop_pay_type_cd -- 止付类型代码
    ,nvl(n.remit_stop_pay_type_cd, o.remit_stop_pay_type_cd) as remit_stop_pay_type_cd -- 解除止付类型代码
    ,nvl(n.surp_tenor, o.surp_tenor) as surp_tenor -- 剩余期限
    ,nvl(n.stl_amt, o.stl_amt) as stl_amt -- 结算金额
    ,nvl(n.sys_in_flg, o.sys_in_flg) as sys_in_flg -- 系统内标志
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.payoff_type_cd, o.payoff_type_cd) as payoff_type_cd -- 结清类型代码
    ,nvl(n.invtry_org_id, o.invtry_org_id) as invtry_org_id -- 库存机构编号
    ,nvl(n.hq_org_id, o.hq_org_id) as hq_org_id -- 总行机构编号
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.evt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_tm n
    full join (select * from ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
where (
        o.evt_id is null
        and o.lp_id is null
    )
    or (
        n.evt_id is null
        and n.lp_id is null
    )
    or (
        o.rgst_id <> n.rgst_id
        or o.agt_id <> n.agt_id
        or o.agt_dtl_id <> n.agt_dtl_id
        or o.bill_id <> n.bill_id
        or o.bus_type_cd <> n.bus_type_cd
        or o.bus_attr_cd <> n.bus_attr_cd
        or o.bill_num <> n.bill_num
        or o.tran_dir_cd <> n.tran_dir_cd
        or o.tran_dt <> n.tran_dt
        or o.reqer_type_cd <> n.reqer_type_cd
        or o.reqer_name <> n.reqer_name
        or o.reqer_soci_crdt_cd <> n.reqer_soci_crdt_cd
        or o.reqer_acct_num <> n.reqer_acct_num
        or o.reqer_mem_id <> n.reqer_mem_id
        or o.reqer_org_id <> n.reqer_org_id
        or o.reqer_pay_sys_bank_no <> n.reqer_pay_sys_bank_no
        or o.recver_type_cd <> n.recver_type_cd
        or o.recver_name <> n.recver_name
        or o.recver_soci_crdt_cd <> n.recver_soci_crdt_cd
        or o.recver_acct_num <> n.recver_acct_num
        or o.recver_mem_code <> n.recver_mem_code
        or o.recver_org_id <> n.recver_org_id
        or o.recver_pay_sys_bank_no <> n.recver_pay_sys_bank_no
        or o.actl_amt <> n.actl_amt
        or o.actl_int <> n.actl_int
        or o.int_rat <> n.int_rat
        or o.stop_pay_type_cd <> n.stop_pay_type_cd
        or o.remit_stop_pay_type_cd <> n.remit_stop_pay_type_cd
        or o.surp_tenor <> n.surp_tenor
        or o.stl_amt <> n.stl_amt
        or o.sys_in_flg <> n.sys_in_flg
        or o.tran_status_cd <> n.tran_status_cd
        or o.payoff_type_cd <> n.payoff_type_cd
        or o.invtry_org_id <> n.invtry_org_id
        or o.hq_org_id <> n.hq_org_id
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_cl(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,agt_id -- 协议编号
    ,agt_dtl_id -- 协议明细编号
    ,bill_id -- 票据编号
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bill_num -- 票据号码
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_mem_id -- 请求方会员编号
    ,reqer_org_id -- 请求方机构编号
    ,reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_num -- 接收方账号
    ,recver_mem_code -- 接收方会员编码
    ,recver_org_id -- 接收方机构编号
    ,recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,actl_amt -- 实付金额
    ,actl_int -- 实付利息
    ,int_rat -- 利率
    ,stop_pay_type_cd -- 止付类型代码
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,sys_in_flg -- 系统内标志
    ,tran_status_cd -- 交易状态代码
    ,payoff_type_cd -- 结清类型代码
    ,invtry_org_id -- 库存机构编号
    ,hq_org_id -- 总行机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_op(
            evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_id -- 登记编号
    ,agt_id -- 协议编号
    ,agt_dtl_id -- 协议明细编号
    ,bill_id -- 票据编号
    ,bus_type_cd -- 业务类型代码
    ,bus_attr_cd -- 业务属性代码
    ,bill_num -- 票据号码
    ,tran_dir_cd -- 交易方向代码
    ,tran_dt -- 交易日期
    ,reqer_type_cd -- 请求方类型代码
    ,reqer_name -- 请求方名称
    ,reqer_soci_crdt_cd -- 请求方社会信用代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_mem_id -- 请求方会员编号
    ,reqer_org_id -- 请求方机构编号
    ,reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,recver_type_cd -- 接收方类型代码
    ,recver_name -- 接收方名称
    ,recver_soci_crdt_cd -- 接收方社会信用代码
    ,recver_acct_num -- 接收方账号
    ,recver_mem_code -- 接收方会员编码
    ,recver_org_id -- 接收方机构编号
    ,recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,actl_amt -- 实付金额
    ,actl_int -- 实付利息
    ,int_rat -- 利率
    ,stop_pay_type_cd -- 止付类型代码
    ,remit_stop_pay_type_cd -- 解除止付类型代码
    ,surp_tenor -- 剩余期限
    ,stl_amt -- 结算金额
    ,sys_in_flg -- 系统内标志
    ,tran_status_cd -- 交易状态代码
    ,payoff_type_cd -- 结清类型代码
    ,invtry_org_id -- 库存机构编号
    ,hq_org_id -- 总行机构编号
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
    ,o.rgst_id -- 登记编号
    ,o.agt_id -- 协议编号
    ,o.agt_dtl_id -- 协议明细编号
    ,o.bill_id -- 票据编号
    ,o.bus_type_cd -- 业务类型代码
    ,o.bus_attr_cd -- 业务属性代码
    ,o.bill_num -- 票据号码
    ,o.tran_dir_cd -- 交易方向代码
    ,o.tran_dt -- 交易日期
    ,o.reqer_type_cd -- 请求方类型代码
    ,o.reqer_name -- 请求方名称
    ,o.reqer_soci_crdt_cd -- 请求方社会信用代码
    ,o.reqer_acct_num -- 请求方账号
    ,o.reqer_mem_id -- 请求方会员编号
    ,o.reqer_org_id -- 请求方机构编号
    ,o.reqer_pay_sys_bank_no -- 请求方支付系统行行号
    ,o.recver_type_cd -- 接收方类型代码
    ,o.recver_name -- 接收方名称
    ,o.recver_soci_crdt_cd -- 接收方社会信用代码
    ,o.recver_acct_num -- 接收方账号
    ,o.recver_mem_code -- 接收方会员编码
    ,o.recver_org_id -- 接收方机构编号
    ,o.recver_pay_sys_bank_no -- 接收方支付系统行行号
    ,o.actl_amt -- 实付金额
    ,o.actl_int -- 实付利息
    ,o.int_rat -- 利率
    ,o.stop_pay_type_cd -- 止付类型代码
    ,o.remit_stop_pay_type_cd -- 解除止付类型代码
    ,o.surp_tenor -- 剩余期限
    ,o.stl_amt -- 结算金额
    ,o.sys_in_flg -- 系统内标志
    ,o.tran_status_cd -- 交易状态代码
    ,o.payoff_type_cd -- 结清类型代码
    ,o.invtry_org_id -- 库存机构编号
    ,o.hq_org_id -- 总行机构编号
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
from ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_bk o
    left join ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_op n
        on
            o.evt_id = n.evt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_cl d
        on
            o.evt_id = d.evt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.evt_rgst_cter_bill_ccution;
--alter table ${iml_schema}.evt_rgst_cter_bill_ccution truncate partition for ('bdmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('evt_rgst_cter_bill_ccution') 
               and substr(subpartition_name,1,8)=upper('p_bdmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.evt_rgst_cter_bill_ccution drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.evt_rgst_cter_bill_ccution modify partition p_bdmsf1 
add subpartition p_bdmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.evt_rgst_cter_bill_ccution exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_cl;
alter table ${iml_schema}.evt_rgst_cter_bill_ccution exchange subpartition p_bdmsf1_20991231 with table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_rgst_cter_bill_ccution to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_tm purge;
drop table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_op purge;
drop table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.evt_rgst_cter_bill_ccution_bdmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_rgst_cter_bill_ccution', partname => 'p_bdmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
