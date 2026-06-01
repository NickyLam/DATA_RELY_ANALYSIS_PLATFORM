/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_payfan_tran_info_h_mrmsf1
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
alter table ${iml_schema}.agt_payfan_tran_info_h add partition p_mrmsf1 values ('mrmsf1')(
        subpartition p_mrmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_mrmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payfan_tran_info_h partition for ('mrmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_op purge;
drop table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,trdpty_indent_id -- 第三方订单编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_num_name -- 收款账号名称
    ,indent_amt -- 订单金额
    ,comm_fee_amt -- 手续费金额
    ,postsc -- 附言
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,bank_bus_flow_num -- 银行业务流水号
    ,trdpty_batch_flow_num -- 第三方批次流水号
    ,bank_batch_flow_num -- 银行批次流水号
    ,pay_flow_num -- 支付流水号
    ,core_flow_num -- 核心流水号
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_payfan_tran_info_h partition for ('mrmsf1')
where 0=1
;

create table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payfan_tran_info_h partition for ('mrmsf1') where 0=1;

create table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_payfan_tran_info_h partition for ('mrmsf1') where 0=1;

-- 3.1 get new data into table
-- mrms_tbl_edu_bth_txn-1
insert into ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,trdpty_indent_id -- 第三方订单编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_num_name -- 收款账号名称
    ,indent_amt -- 订单金额
    ,comm_fee_amt -- 手续费金额
    ,postsc -- 附言
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,bank_bus_flow_num -- 银行业务流水号
    ,trdpty_batch_flow_num -- 第三方批次流水号
    ,bank_batch_flow_num -- 银行批次流水号
    ,pay_flow_num -- 支付流水号
    ,core_flow_num -- 核心流水号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300042'||P1.ORDER_NUM -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ORDER_NUM -- 第三方订单编号
    ,P1.MERCH_NUM -- 商户编号
    ,P1.MERCH_NAME -- 商户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.TRAN_TYPE END -- 交易类型代码
    ,${iml_schema}.dateformat_max2(P1.TRAN_DATE||P1.TRAN_TIME) -- 交易日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TXN_STATUS END -- 交易状态代码
    ,P1.PAY_ACCT -- 付款账户编号
    ,P1.PAY_ACCT_NAME -- 付款账户名称
    ,P1.RCV_ACCT -- 收款账户编号
    ,P1.RECV_ACCT_NAME -- 收款账号名称
    ,P1.ORDER_AMT -- 订单金额
    ,P1.FEE_AMT -- 手续费金额
    ,P1.POST -- 附言
    ,P1.RET_CODE -- 响应码
    ,P1.RET_MSG -- 响应信息
    ,${iml_schema}.timeformat_min(P1.CREATED_TIME) -- 创建时间
    ,${iml_schema}.timeformat_max2(P1.UPDATED_TIME) -- 修改时间
    ,P1.PLATF_SEQ_NUM -- 银行业务流水号
    ,P1.CHN_BAT_SEQ_NUM -- 第三方批次流水号
    ,P1.SEQ -- 银行批次流水号
    ,P1.PAY_SEQ_NUM -- 支付流水号
    ,P1.CORE_SEQ_NUM -- 核心流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mrms_tbl_edu_bth_txn' -- 源表名称
    ,'mrmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mrms_tbl_edu_bth_txn p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TRAN_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MRMS'
        AND R1.SRC_TAB_EN_NAME= 'MRMS_TBL_EDU_BTH_TXN'
        AND R1.SRC_FIELD_EN_NAME= 'TRAN_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_PAYFAN_TRAN_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TXN_STATUS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MRMS'
        AND R2.SRC_TAB_EN_NAME= 'MRMS_TBL_EDU_BTH_TXN'
        AND R2.SRC_FIELD_EN_NAME= 'TXN_STATUS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_PAYFAN_TRAN_INFO_H'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TRAN_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_tm 
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


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,trdpty_indent_id -- 第三方订单编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_num_name -- 收款账号名称
    ,indent_amt -- 订单金额
    ,comm_fee_amt -- 手续费金额
    ,postsc -- 附言
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,bank_bus_flow_num -- 银行业务流水号
    ,trdpty_batch_flow_num -- 第三方批次流水号
    ,bank_batch_flow_num -- 银行批次流水号
    ,pay_flow_num -- 支付流水号
    ,core_flow_num -- 核心流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,trdpty_indent_id -- 第三方订单编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_num_name -- 收款账号名称
    ,indent_amt -- 订单金额
    ,comm_fee_amt -- 手续费金额
    ,postsc -- 附言
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,bank_bus_flow_num -- 银行业务流水号
    ,trdpty_batch_flow_num -- 第三方批次流水号
    ,bank_batch_flow_num -- 银行批次流水号
    ,pay_flow_num -- 支付流水号
    ,core_flow_num -- 核心流水号
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
    ,nvl(n.trdpty_indent_id, o.trdpty_indent_id) as trdpty_indent_id -- 第三方订单编号
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.mercht_name, o.mercht_name) as mercht_name -- 商户名称
    ,nvl(n.tran_type_cd, o.tran_type_cd) as tran_type_cd -- 交易类型代码
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.tran_status_cd, o.tran_status_cd) as tran_status_cd -- 交易状态代码
    ,nvl(n.pay_acct_id, o.pay_acct_id) as pay_acct_id -- 付款账户编号
    ,nvl(n.pay_acct_name, o.pay_acct_name) as pay_acct_name -- 付款账户名称
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.recvbl_num_name, o.recvbl_num_name) as recvbl_num_name -- 收款账号名称
    ,nvl(n.indent_amt, o.indent_amt) as indent_amt -- 订单金额
    ,nvl(n.comm_fee_amt, o.comm_fee_amt) as comm_fee_amt -- 手续费金额
    ,nvl(n.postsc, o.postsc) as postsc -- 附言
    ,nvl(n.resp_code, o.resp_code) as resp_code -- 响应码
    ,nvl(n.resp_info, o.resp_info) as resp_info -- 响应信息
    ,nvl(n.create_tm, o.create_tm) as create_tm -- 创建时间
    ,nvl(n.modif_tm, o.modif_tm) as modif_tm -- 修改时间
    ,nvl(n.bank_bus_flow_num, o.bank_bus_flow_num) as bank_bus_flow_num -- 银行业务流水号
    ,nvl(n.trdpty_batch_flow_num, o.trdpty_batch_flow_num) as trdpty_batch_flow_num -- 第三方批次流水号
    ,nvl(n.bank_batch_flow_num, o.bank_batch_flow_num) as bank_batch_flow_num -- 银行批次流水号
    ,nvl(n.pay_flow_num, o.pay_flow_num) as pay_flow_num -- 支付流水号
    ,nvl(n.core_flow_num, o.core_flow_num) as core_flow_num -- 核心流水号
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_tm n
    full join (select * from ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
where (
        o.agt_id is null
        and o.lp_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
    )
    or (
        o.trdpty_indent_id <> n.trdpty_indent_id
        or o.mercht_id <> n.mercht_id
        or o.mercht_name <> n.mercht_name
        or o.tran_type_cd <> n.tran_type_cd
        or o.tran_dt <> n.tran_dt
        or o.tran_status_cd <> n.tran_status_cd
        or o.pay_acct_id <> n.pay_acct_id
        or o.pay_acct_name <> n.pay_acct_name
        or o.recvbl_acct_id <> n.recvbl_acct_id
        or o.recvbl_num_name <> n.recvbl_num_name
        or o.indent_amt <> n.indent_amt
        or o.comm_fee_amt <> n.comm_fee_amt
        or o.postsc <> n.postsc
        or o.resp_code <> n.resp_code
        or o.resp_info <> n.resp_info
        or o.create_tm <> n.create_tm
        or o.modif_tm <> n.modif_tm
        or o.bank_bus_flow_num <> n.bank_bus_flow_num
        or o.trdpty_batch_flow_num <> n.trdpty_batch_flow_num
        or o.bank_batch_flow_num <> n.bank_batch_flow_num
        or o.pay_flow_num <> n.pay_flow_num
        or o.core_flow_num <> n.core_flow_num
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,trdpty_indent_id -- 第三方订单编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_num_name -- 收款账号名称
    ,indent_amt -- 订单金额
    ,comm_fee_amt -- 手续费金额
    ,postsc -- 附言
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,bank_bus_flow_num -- 银行业务流水号
    ,trdpty_batch_flow_num -- 第三方批次流水号
    ,bank_batch_flow_num -- 银行批次流水号
    ,pay_flow_num -- 支付流水号
    ,core_flow_num -- 核心流水号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,trdpty_indent_id -- 第三方订单编号
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,tran_type_cd -- 交易类型代码
    ,tran_dt -- 交易日期
    ,tran_status_cd -- 交易状态代码
    ,pay_acct_id -- 付款账户编号
    ,pay_acct_name -- 付款账户名称
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_num_name -- 收款账号名称
    ,indent_amt -- 订单金额
    ,comm_fee_amt -- 手续费金额
    ,postsc -- 附言
    ,resp_code -- 响应码
    ,resp_info -- 响应信息
    ,create_tm -- 创建时间
    ,modif_tm -- 修改时间
    ,bank_bus_flow_num -- 银行业务流水号
    ,trdpty_batch_flow_num -- 第三方批次流水号
    ,bank_batch_flow_num -- 银行批次流水号
    ,pay_flow_num -- 支付流水号
    ,core_flow_num -- 核心流水号
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
    ,o.trdpty_indent_id -- 第三方订单编号
    ,o.mercht_id -- 商户编号
    ,o.mercht_name -- 商户名称
    ,o.tran_type_cd -- 交易类型代码
    ,o.tran_dt -- 交易日期
    ,o.tran_status_cd -- 交易状态代码
    ,o.pay_acct_id -- 付款账户编号
    ,o.pay_acct_name -- 付款账户名称
    ,o.recvbl_acct_id -- 收款账户编号
    ,o.recvbl_num_name -- 收款账号名称
    ,o.indent_amt -- 订单金额
    ,o.comm_fee_amt -- 手续费金额
    ,o.postsc -- 附言
    ,o.resp_code -- 响应码
    ,o.resp_info -- 响应信息
    ,o.create_tm -- 创建时间
    ,o.modif_tm -- 修改时间
    ,o.bank_bus_flow_num -- 银行业务流水号
    ,o.trdpty_batch_flow_num -- 第三方批次流水号
    ,o.bank_batch_flow_num -- 银行批次流水号
    ,o.pay_flow_num -- 支付流水号
    ,o.core_flow_num -- 核心流水号
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
from ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_bk o
    left join ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_payfan_tran_info_h;
--alter table ${iml_schema}.agt_payfan_tran_info_h truncate partition for ('mrmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_payfan_tran_info_h') 
               and substr(subpartition_name,1,8)=upper('p_mrmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_payfan_tran_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

alter table ${iml_schema}.agt_payfan_tran_info_h modify partition p_mrmsf1 
add subpartition p_mrmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_payfan_tran_info_h exchange subpartition p_mrmsf1_${batch_date} with table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_cl;
alter table ${iml_schema}.agt_payfan_tran_info_h exchange subpartition p_mrmsf1_20991231 with table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_payfan_tran_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_tm purge;
drop table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_op purge;
drop table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_payfan_tran_info_h_mrmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_payfan_tran_info_h', partname => 'p_mrmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
