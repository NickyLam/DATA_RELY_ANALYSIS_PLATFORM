/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_up_indent_info_h_amssf1
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
alter table ${iml_schema}.agt_up_indent_info_h add partition p_amssf1 values ('amssf1')(
        subpartition p_amssf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_amssf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_up_indent_info_h_amssf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_up_indent_info_h partition for ('amssf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_up_indent_info_h_amssf1_tm purge;
drop table ${iml_schema}.agt_up_indent_info_h_amssf1_op purge;
drop table ${iml_schema}.agt_up_indent_info_h_amssf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_up_indent_info_h_amssf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,order_no -- 订单号
    ,fund_corp_id -- 基金公司编号
    ,unionpay_mercht_id -- 银联商户编号
    ,belong_org_id -- 所属机构编号
    ,org_id -- 机构编号
    ,payfan_chn_id -- 代付渠道编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_no -- 收款银行行号
    ,recvbl_bank_name -- 收款银行名称
    ,recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,bank_int_recvbl_acct_flg -- 行内收款账户标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_core_type_cd -- 付款账户核心类型代码
    ,init_tran_date -- 原交易日期
    ,init_tran_id -- 原交易编号
    ,fail_rs -- 失败原因
    ,valid_flg -- 有效标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_up_indent_info_h partition for ('amssf1')
where 0=1
;

create table ${iml_schema}.agt_up_indent_info_h_amssf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_up_indent_info_h partition for ('amssf1') where 0=1;

create table ${iml_schema}.agt_up_indent_info_h_amssf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_up_indent_info_h partition for ('amssf1') where 0=1;

-- 3.1 get new data into table
-- amss_union_pay_order-1
insert into ${iml_schema}.agt_up_indent_info_h_amssf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,order_no -- 订单号
    ,fund_corp_id -- 基金公司编号
    ,unionpay_mercht_id -- 银联商户编号
    ,belong_org_id -- 所属机构编号
    ,org_id -- 机构编号
    ,payfan_chn_id -- 代付渠道编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_no -- 收款银行行号
    ,recvbl_bank_name -- 收款银行名称
    ,recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,bank_int_recvbl_acct_flg -- 行内收款账户标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_core_type_cd -- 付款账户核心类型代码
    ,init_tran_date -- 原交易日期
    ,init_tran_id -- 原交易编号
    ,fail_rs -- 失败原因
    ,valid_flg -- 有效标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300073'||P1.ORDER_NUM||P1.UNION_PAY_ORDER_ID -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ORDER_NUM -- 订单号
    ,P1.FUND_ID -- 基金公司编号
    ,P1.MERCHANT_ID -- 银联商户编号
    ,P1.CHANNEL_ID -- 所属机构编号
    ,P1.ORG_ID -- 机构编号
    ,P1.MGMT_PLATF_CHN -- 代付渠道编号
    ,nvl(trim(P1.IDEN_TYPE_CD),'0000') -- 证件类型代码
    ,P1.CERT_NUM -- 证件号码
    ,P1.CEPH_NUM -- 手机号码
    ,P1.TXN_AMT -- 交易金额
    ,nvl(trim(to_char(P1.TXN_STATUS)),'-') -- 交易状态代码
    ,P1.TXN_DATE -- 交易日期
    ,P1.RCV_ACCT -- 收款账户编号
    ,P1.RCV_ACCT_NAME -- 收款账户名称
    ,decode(P1.RCV_ACCT_TYP,'0','2' ,'1','11' ,'2','12' ,' ','-' ,P1.RCV_ACCT_TYP) -- 收款账户类型代码
    ,P1.RCV_BANK_ID -- 收款银行行号
    ,P1.RCV_BANK_NAME -- 收款银行名称
    ,nvl(trim(P1.RCV_ACCT_BCS_TYP),'-') -- 收款账户核心类型代码
    ,to_char(decode(P1.RCV_BANK_CATEG,'1','1','2','0','0','-',P1.RCV_BANK_CATEG)) -- 行内收款账户标志
    ,P1.PAYER_ACCT -- 付款账户编号
    ,P1.PAYER_NAME -- 付款账户名称
    ,decode(P1.PAYER_ACCT_TYP,'0','2' ,'1','11' ,'2','12' ,' ','-' ,P1.PAYER_ACCT_TYP) -- 付款账户类型代码
    ,nvl(trim(P1.PAYER_ACCT_BCS_TYP),'-') -- 付款账户核心类型代码
    ,${iml_schema}.timeformat_max2(P1.ORI_TRX_DT) -- 原交易日期
    ,P1.ORI_TRX_SEQ -- 原交易编号
    ,P1.RESP_MSG -- 失败原因
    ,case when P1.PHYSICS_FLAG = 1 then '1' else '0' end -- 有效标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'amss_union_pay_order' -- 源表名称
    ,'amssf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.amss_union_pay_order p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_up_indent_info_h_amssf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,order_no
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
        into ${iml_schema}.agt_up_indent_info_h_amssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,order_no -- 订单号
    ,fund_corp_id -- 基金公司编号
    ,unionpay_mercht_id -- 银联商户编号
    ,belong_org_id -- 所属机构编号
    ,org_id -- 机构编号
    ,payfan_chn_id -- 代付渠道编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_no -- 收款银行行号
    ,recvbl_bank_name -- 收款银行名称
    ,recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,bank_int_recvbl_acct_flg -- 行内收款账户标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_core_type_cd -- 付款账户核心类型代码
    ,init_tran_date -- 原交易日期
    ,init_tran_id -- 原交易编号
    ,fail_rs -- 失败原因
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_up_indent_info_h_amssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,order_no -- 订单号
    ,fund_corp_id -- 基金公司编号
    ,unionpay_mercht_id -- 银联商户编号
    ,belong_org_id -- 所属机构编号
    ,org_id -- 机构编号
    ,payfan_chn_id -- 代付渠道编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_no -- 收款银行行号
    ,recvbl_bank_name -- 收款银行名称
    ,recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,bank_int_recvbl_acct_flg -- 行内收款账户标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_core_type_cd -- 付款账户核心类型代码
    ,init_tran_date -- 原交易日期
    ,init_tran_id -- 原交易编号
    ,fail_rs -- 失败原因
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.order_no, o.order_no) as order_no -- 订单号
    ,nvl(n.fund_corp_id, o.fund_corp_id) as fund_corp_id -- 基金公司编号
    ,nvl(n.unionpay_mercht_id, o.unionpay_mercht_id) as unionpay_mercht_id -- 银联商户编号
    ,nvl(n.belong_org_id, o.belong_org_id) as belong_org_id -- 所属机构编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.payfan_chn_id, o.payfan_chn_id) as payfan_chn_id -- 代付渠道编号
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 手机号码
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_acct_name, o.recvbl_acct_name) as recvbl_acct_name -- 收款账户名称
    ,nvl(n.recvbl_acct_type_cd, o.recvbl_acct_type_cd) as recvbl_acct_type_cd -- 收款账户类型代码
    ,nvl(n.recvbl_bank_no, o.recvbl_bank_no) as recvbl_bank_no -- 收款银行行号
    ,nvl(n.recvbl_bank_name, o.recvbl_bank_name) as recvbl_bank_name -- 收款银行名称
    ,nvl(n.recvbl_acct_core_type_cd, o.recvbl_acct_core_type_cd) as recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,nvl(n.bank_int_recvbl_acct_flg, o.bank_int_recvbl_acct_flg) as bank_int_recvbl_acct_flg -- 行内收款账户标志
    ,nvl(n.pay_acct_id, o.pay_acct_id) as pay_acct_id -- 付款账户编号
    ,nvl(n.pay_acct_name, o.pay_acct_name) as pay_acct_name -- 付款账户名称
    ,nvl(n.pay_acct_type_cd, o.pay_acct_type_cd) as pay_acct_type_cd -- 付款账户类型代码
    ,nvl(n.pay_acct_core_type_cd, o.pay_acct_core_type_cd) as pay_acct_core_type_cd -- 付款账户核心类型代码
    ,nvl(n.init_tran_date, o.init_tran_date) as init_tran_date -- 原交易日期
    ,nvl(n.init_tran_id, o.init_tran_id) as init_tran_id -- 原交易编号
    ,nvl(n.fail_rs, o.fail_rs) as fail_rs -- 失败原因
    ,nvl(n.valid_flg, o.valid_flg) as valid_flg -- 有效标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.order_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.order_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.order_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_up_indent_info_h_amssf1_tm n
    full join (select * from ${iml_schema}.agt_up_indent_info_h_amssf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.order_no = n.order_no
where (
        o.agt_id is null
        and o.lp_id is null
        and o.order_no is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.order_no is null
    )
    or (
        o.fund_corp_id <> n.fund_corp_id
        or o.unionpay_mercht_id <> n.unionpay_mercht_id
        or o.belong_org_id <> n.belong_org_id
        or o.org_id <> n.org_id
        or o.payfan_chn_id <> n.payfan_chn_id
        or o.cert_type_cd <> n.cert_type_cd
        or o.cert_no <> n.cert_no
        or o.mobile_no <> n.mobile_no
        or o.tran_amt <> n.tran_amt
        or o.tran_status_cd <> n.tran_status_cd
        or o.tran_dt <> n.tran_dt
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_acct_name <> n.recvbl_acct_name
        or o.recvbl_acct_type_cd <> n.recvbl_acct_type_cd
        or o.recvbl_bank_no <> n.recvbl_bank_no
        or o.recvbl_bank_name <> n.recvbl_bank_name
        or o.recvbl_acct_core_type_cd <> n.recvbl_acct_core_type_cd
        or o.bank_int_recvbl_acct_flg <> n.bank_int_recvbl_acct_flg
        or o.pay_acct_id <> n.pay_acct_id
        or o.pay_acct_name <> n.pay_acct_name
        or o.pay_acct_type_cd <> n.pay_acct_type_cd
        or o.pay_acct_core_type_cd <> n.pay_acct_core_type_cd
        or o.init_tran_date <> n.init_tran_date
        or o.init_tran_id <> n.init_tran_id
        or o.fail_rs <> n.fail_rs
        or o.valid_flg <> n.valid_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_up_indent_info_h_amssf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,order_no -- 订单号
    ,fund_corp_id -- 基金公司编号
    ,unionpay_mercht_id -- 银联商户编号
    ,belong_org_id -- 所属机构编号
    ,org_id -- 机构编号
    ,payfan_chn_id -- 代付渠道编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_no -- 收款银行行号
    ,recvbl_bank_name -- 收款银行名称
    ,recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,bank_int_recvbl_acct_flg -- 行内收款账户标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_core_type_cd -- 付款账户核心类型代码
    ,init_tran_date -- 原交易日期
    ,init_tran_id -- 原交易编号
    ,fail_rs -- 失败原因
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_up_indent_info_h_amssf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,order_no -- 订单号
    ,fund_corp_id -- 基金公司编号
    ,unionpay_mercht_id -- 银联商户编号
    ,belong_org_id -- 所属机构编号
    ,org_id -- 机构编号
    ,payfan_chn_id -- 代付渠道编号
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,tran_amt -- 交易金额
    ,tran_status_cd -- 交易状态代码
    ,tran_dt -- 交易日期
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_acct_name -- 收款账户名称
    ,recvbl_acct_type_cd -- 收款账户类型代码
    ,recvbl_bank_no -- 收款银行行号
    ,recvbl_bank_name -- 收款银行名称
    ,recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,bank_int_recvbl_acct_flg -- 行内收款账户标志
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,pay_acct_type_cd -- 付款账户类型代码
    ,pay_acct_core_type_cd -- 付款账户核心类型代码
    ,init_tran_date -- 原交易日期
    ,init_tran_id -- 原交易编号
    ,fail_rs -- 失败原因
    ,valid_flg -- 有效标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.order_no -- 订单号
    ,o.fund_corp_id -- 基金公司编号
    ,o.unionpay_mercht_id -- 银联商户编号
    ,o.belong_org_id -- 所属机构编号
    ,o.org_id -- 机构编号
    ,o.payfan_chn_id -- 代付渠道编号
    ,o.cert_type_cd -- 证件类型代码
    ,o.cert_no -- 证件号码
    ,o.mobile_no -- 手机号码
    ,o.tran_amt -- 交易金额
    ,o.tran_status_cd -- 交易状态代码
    ,o.tran_dt -- 交易日期
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_acct_name -- 收款账户名称
    ,o.recvbl_acct_type_cd -- 收款账户类型代码
    ,o.recvbl_bank_no -- 收款银行行号
    ,o.recvbl_bank_name -- 收款银行名称
    ,o.recvbl_acct_core_type_cd -- 收款账户核心类型代码
    ,o.bank_int_recvbl_acct_flg -- 行内收款账户标志
    ,o.pay_acct_id -- 付款账户编号
    ,o.pay_acct_name -- 付款账户名称
    ,o.pay_acct_type_cd -- 付款账户类型代码
    ,o.pay_acct_core_type_cd -- 付款账户核心类型代码
    ,o.init_tran_date -- 原交易日期
    ,o.init_tran_id -- 原交易编号
    ,o.fail_rs -- 失败原因
    ,o.valid_flg -- 有效标志
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
from ${iml_schema}.agt_up_indent_info_h_amssf1_bk o
    left join ${iml_schema}.agt_up_indent_info_h_amssf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.order_no = n.order_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_up_indent_info_h_amssf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.order_no = d.order_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_up_indent_info_h;
--alter table ${iml_schema}.agt_up_indent_info_h truncate partition for ('amssf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_up_indent_info_h') 
               and substr(subpartition_name,1,8)=upper('p_amssf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_up_indent_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_up_indent_info_h modify partition p_amssf1 
add subpartition p_amssf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_up_indent_info_h exchange subpartition p_amssf1_${batch_date} with table ${iml_schema}.agt_up_indent_info_h_amssf1_cl;
alter table ${iml_schema}.agt_up_indent_info_h exchange subpartition p_amssf1_20991231 with table ${iml_schema}.agt_up_indent_info_h_amssf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_up_indent_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_up_indent_info_h_amssf1_tm purge;
drop table ${iml_schema}.agt_up_indent_info_h_amssf1_op purge;
drop table ${iml_schema}.agt_up_indent_info_h_amssf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_up_indent_info_h_amssf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_up_indent_info_h', partname => 'p_amssf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
