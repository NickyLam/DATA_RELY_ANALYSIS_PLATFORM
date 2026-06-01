/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_ic_card_tran_flow_ncbsi1
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
drop table ${iml_schema}.evt_ic_card_tran_flow_ncbsi1_tm purge;
alter table ${iml_schema}.evt_ic_card_tran_flow add partition p_ncbsi1 values ('ncbsi1')(
        subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_ic_card_tran_flow modify partition p_ncbsi1
    add subpartition p_ncbsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ic_card_tran_flow_ncbsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,tran_chn_id -- 交易渠道编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,sys_flow_num -- 系统流水号
    ,tran_ref_no -- 交易参考号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,tran_code -- 交易码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt -- 交易金额
    ,ic_card_tran_status_cd -- IC卡交易状态代码
    ,tran_status_code -- 交易状态码
    ,debit_crdt_flg -- 借贷标志
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,serv_status_descb -- 服务状态描述
    ,app_idf -- 应用标识符
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_termn_id -- 交易终端编号
    ,mercht_id -- 商户编号
    ,clear_dt -- 清算日期
    ,cntpty_acct_num -- 交易对手账号
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,cust_name -- 客户名称
    ,cust_cert_type_cd -- 客户证件类型代码
    ,cust_cert_no -- 客户证件号码
    ,public_agent_name -- 代办人姓名
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_cert_no -- 代办人证件号码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_ic_card_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- ncbs_ic_tran_list-1
insert into ${iml_schema}.evt_ic_card_tran_flow_ncbsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,plat_tran_flow_num -- 平台交易流水号
    ,plat_tran_dt -- 平台交易日期
    ,tran_chn_id -- 交易渠道编号
    ,ova_flow_num -- 全局流水号
    ,bus_flow_num -- 业务流水号
    ,sys_flow_num -- 系统流水号
    ,tran_ref_no -- 交易参考号
    ,card_no -- 卡号
    ,card_ser_num -- 卡序列号
    ,tran_code -- 交易码
    ,tran_curr_cd -- 交易币种代码
    ,tran_amt -- 交易金额
    ,ic_card_tran_status_cd -- IC卡交易状态代码
    ,tran_status_code -- 交易状态码
    ,debit_crdt_flg -- 借贷标志
    ,tran_dt -- 交易日期
    ,tran_tm -- 交易时间
    ,serv_status_descb -- 服务状态描述
    ,app_idf -- 应用标识符
    ,tran_teller_id -- 交易柜员编号
    ,tran_org_id -- 交易机构编号
    ,tran_termn_id -- 交易终端编号
    ,mercht_id -- 商户编号
    ,clear_dt -- 清算日期
    ,cntpty_acct_num -- 交易对手账号
    ,elec_cash_acct_bal -- 电子现金账户余额
    ,cust_name -- 客户名称
    ,cust_cert_type_cd -- 客户证件类型代码
    ,cust_cert_no -- 客户证件号码
    ,public_agent_name -- 代办人姓名
    ,public_agent_cert_type_cd -- 代办人证件类型代码
    ,public_agent_cert_no -- 代办人证件号码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101017'||P1.TRAN_SEQ -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TRAN_SEQ -- 平台交易流水号
    ,P1.TRAN_DATE -- 平台交易日期
    ,P1.TXN_CHN_NUM -- 交易渠道编号
    ,P1.GLOB_SEQ_NUM -- 全局流水号
    ,P1.BIZ_SEQ_NUM -- 业务流水号
    ,P1.SYS_SEQ_NUM -- 系统流水号
    ,P1.REFERENCE -- 交易参考号
    ,P1.CARD_NO -- 卡号
    ,P1.IC_CARD_SEQ -- 卡序列号
    ,P1.TRAN_CODE -- 交易码
    ,nvl(trim(P1.CCY),'-') -- 交易币种代码
    ,P1.TRAN_AMT -- 交易金额
    ,nvl(trim(P1.TRAN_STAT),'-') -- IC卡交易状态代码
    ,P1.RET_CODE -- 交易状态码
    ,nvl(trim(P1.DB_CR_DIR_CD),'-') -- 借贷标志
    ,P1.TXN_DT -- 交易日期
    ,P1.TXN_TM -- 交易时间
    ,P1.RET_MSG -- 服务状态描述
    ,P1.IC_AID -- 应用标识符
    ,P1.TXN_TELL -- 交易柜员编号
    ,P1.TXN_ORG_NUM -- 交易机构编号
    ,P1.TERM_NO -- 交易终端编号
    ,P1.MERCH_NO -- 商户编号
    ,P1.SETL_DATE -- 清算日期
    ,P1.OTH_BASE_ACCT_NO -- 交易对手账号
    ,P1.IC_ACT_BAL -- 电子现金账户余额
    ,P1.CLIENT_NAME -- 客户名称
    ,nvl(trim(P1.DOCUMENT_TYPE),'0000') -- 客户证件类型代码
    ,P1.DOCUMENT_ID -- 客户证件号码
    ,P1.COMMISSION_CLIENT_NAME -- 代办人姓名
    ,nvl(trim(P1.COMMISSION_DOCUMENT_TYPE),'0000') -- 代办人证件类型代码
    ,P1.COMMISSION_DOCUMENT_ID -- 代办人证件号码
    ,P1.MEMO_CNTT -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_ic_tran_list' -- 源表名称
    ,'ncbsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_ic_tran_list p1
where  1 = 1 
    and P1.ETL_DT=TO_DATE('${batch_date}','YYYYMMDD')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_ic_card_tran_flow truncate subpartition p_ncbsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_ic_card_tran_flow exchange subpartition p_ncbsi1_${batch_date} with table ${iml_schema}.evt_ic_card_tran_flow_ncbsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_ic_card_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_ic_card_tran_flow_ncbsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_ic_card_tran_flow', partname => 'p_ncbsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);