/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_sell_fx_info_flow_mpcsf1
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
drop table ${iml_schema}.evt_sell_fx_info_flow_mpcsf1_tm purge;
alter table ${iml_schema}.evt_sell_fx_info_flow add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_sell_fx_info_flow modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_sell_fx_info_flow_mpcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,sell_fx_tran_status_cd -- 购汇交易状态代码
    ,sell_fx_tran_type_cd -- 购汇交易类型代码
    ,bank_flow_num -- 银行流水号
    ,sell_fx_bus_type_cd -- 购汇业务类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cty_rg_cd -- 国家地区代码
    ,attach_cert_no -- 补充证件号码
    ,cust_name -- 客户名称
    ,sell_fx_cap_attr_cd -- 购汇资金属性代码
    ,curr_cd -- 币种代码
    ,sell_fx_amt -- 购汇金额
    ,sell_fx_cash_amt -- 购汇提钞金额
    ,remit_out_amt -- 汇出金额
    ,depot_indv_fx_acct_amt -- 存入个人外汇账户金额
    ,bk_check_amt -- 旅行支票金额
    ,sell_fx_cny_acct_id -- 购汇人民币账户编号
    ,indv_fx_acct_id -- 个人外汇账户编号
    ,bus_trast_src_cd -- 业务办理来源代码
    ,fx_doc_id -- 外汇局文件编号
    ,bus_trast_tm -- 业务办理时间
    ,input_rs_cd -- 补录原因代码
    ,input_comnt -- 补录说明
    ,remark -- 备注
    ,bus_flow_num -- 业务流水号
    ,rtn_rcpt_bank_flow_num -- 回执银行流水号
    ,ths_sell_fx_usd_amt -- 本次购汇折美元金额
    ,tyr_sell_fx_usd_surp_lmt -- 本年购汇折美元剩余额度
    ,indv_main_cls_status_cd -- 个人主体分类状态代码
    ,issue_dt -- 发布日期
    ,exp_dt -- 到期日期
    ,issue_rs -- 发布原因
    ,issue_rs_cd -- 发布原因代码
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,init_node -- 发起节点
    ,acpt_node -- 接受节点
    ,send_tm -- 发送时间
    ,msg_id -- 报文编号
    ,tran_info_desc -- 交易信息描述
    ,src_sys_cd -- 源系统代码
    ,sorc_sys_flow_num -- 源系统流水号
    ,modif_rs_cd -- 修改原因代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_sell_fx_info_flow
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a0jtpmisaddghfxseinfo-1
insert into ${iml_schema}.evt_sell_fx_info_flow_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,midgrod_flow_num -- 中台流水号
    ,tran_dt -- 交易日期
    ,sell_fx_tran_status_cd -- 购汇交易状态代码
    ,sell_fx_tran_type_cd -- 购汇交易类型代码
    ,bank_flow_num -- 银行流水号
    ,sell_fx_bus_type_cd -- 购汇业务类型代码
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,cty_rg_cd -- 国家地区代码
    ,attach_cert_no -- 补充证件号码
    ,cust_name -- 客户名称
    ,sell_fx_cap_attr_cd -- 购汇资金属性代码
    ,curr_cd -- 币种代码
    ,sell_fx_amt -- 购汇金额
    ,sell_fx_cash_amt -- 购汇提钞金额
    ,remit_out_amt -- 汇出金额
    ,depot_indv_fx_acct_amt -- 存入个人外汇账户金额
    ,bk_check_amt -- 旅行支票金额
    ,sell_fx_cny_acct_id -- 购汇人民币账户编号
    ,indv_fx_acct_id -- 个人外汇账户编号
    ,bus_trast_src_cd -- 业务办理来源代码
    ,fx_doc_id -- 外汇局文件编号
    ,bus_trast_tm -- 业务办理时间
    ,input_rs_cd -- 补录原因代码
    ,input_comnt -- 补录说明
    ,remark -- 备注
    ,bus_flow_num -- 业务流水号
    ,rtn_rcpt_bank_flow_num -- 回执银行流水号
    ,ths_sell_fx_usd_amt -- 本次购汇折美元金额
    ,tyr_sell_fx_usd_surp_lmt -- 本年购汇折美元剩余额度
    ,indv_main_cls_status_cd -- 个人主体分类状态代码
    ,issue_dt -- 发布日期
    ,exp_dt -- 到期日期
    ,issue_rs -- 发布原因
    ,issue_rs_cd -- 发布原因代码
    ,err_cd -- 错误码
    ,err_info_desc -- 错误信息描述
    ,init_node -- 发起节点
    ,acpt_node -- 接受节点
    ,send_tm -- 发送时间
    ,msg_id -- 报文编号
    ,tran_info_desc -- 交易信息描述
    ,src_sys_cd -- 源系统代码
    ,sorc_sys_flow_num -- 源系统流水号
    ,modif_rs_cd -- 修改原因代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401014'||P1.MAINSEQ||P1.TRANSDT -- 事件编号
    ,'9999' -- 法人编号
    ,P1.MAINSEQ -- 中台流水号
    ,${iml_schema}.DATEFORMAT_MIN(P1.TRANSDT) -- 交易日期
    ,nvl(trim(p1.STATUS),'-') -- 购汇交易状态代码
    ,nvl(trim(p1.TRANTYPE),'-') -- 购汇交易类型代码
    ,P1.BANK_SELF_NUM -- 银行流水号
    ,nvl(trim(p1.BIZ_TYPE_CODE),'-') -- 购汇业务类型代码
    ,nvl(trim(p1.IDTYPE_CODE),'0000') -- 证件类型代码
    ,P1.IDCODE -- 证件号码
    ,nvl(trim(p1.CTYCODE),'XXX') -- 国家地区代码
    ,P1.ADD_IDCODE -- 补充证件号码
    ,P1.PERSON_NAME -- 客户名称
    ,nvl(trim(p1.PURFX_TYPE_CODE),'-') -- 购汇资金属性代码
    ,nvl(trim(p1.TXCCY),'-') -- 币种代码
    ,nvl(trim(P1.PURFX_AMT),'0') -- 购汇金额
    ,nvl(trim(P1.PURFX_CASH_AMT),'0') -- 购汇提钞金额
    ,nvl(trim(P1.FCY_REMIT_AMT),'0') -- 汇出金额
    ,nvl(trim(P1.FCY_ACCT_AMT),'0') -- 存入个人外汇账户金额
    ,nvl(trim(P1.TCHK_AMT),'0') -- 旅行支票金额
    ,P1.PURFX_ACCT_CNY -- 购汇人民币账户编号
    ,P1.LCY_ACCT_NO -- 个人外汇账户编号
    ,nvl(trim(p1.BIZ_TX_CHNL_CODE),'-') -- 业务办理来源代码
    ,P1.CAPITALNO -- 外汇局文件编号
    ,${iml_schema}.timeformat_min(P1.BIZ_TX_TIME) -- 业务办理时间
    ,nvl(trim(p1.REIN_REASON_CODE),'-') -- 补录原因代码
    ,P1.REIN_REMARK -- 补录说明
    ,P1.REMARK -- 备注
    ,P1.REFNO -- 业务流水号
    ,P1.RET_BANK_SELF_NUM -- 回执银行流水号
    ,nvl(trim(P1.PURFX_AMT_USD),'0') -- 本次购汇折美元金额
    ,nvl(trim(P1.ANN_REM_FCYAMT_USD),'0') -- 本年购汇折美元剩余额度
    ,nvl(trim(p1.TYPE_STATUS),'-') -- 个人主体分类状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.PUB_DATE) -- 发布日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.END_DATE) -- 到期日期
    ,P1.PUB_REASON -- 发布原因
    ,nvl(trim(p1.PUB_CODE),'-') -- 发布原因代码
    ,P1.CODE -- 错误码
    ,P1.DETAIL -- 错误信息描述
    ,P1.PCKHEADSRC -- 发起节点
    ,P1.PCKHEADDES -- 接受节点
    ,${iml_schema}.timeformat_min(P1.PCKHEADSENDTIME) -- 发送时间
    ,P1.PCKHEADMSGNO -- 报文编号
    ,P1.TRANSMESSAGE -- 交易信息描述
    ,nvl(trim(p1.SRCSYSID),'-') -- 源系统代码
    ,P1.SRCSEQNO -- 源系统流水号
    ,nvl(trim(p1.EDIT_REASON_CODE),'-') -- 修改原因代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0jtpmisaddghfxseinfo' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0jtpmisaddghfxseinfo p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_sell_fx_info_flow truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_sell_fx_info_flow exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_sell_fx_info_flow_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_sell_fx_info_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_sell_fx_info_flow_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_sell_fx_info_flow', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);