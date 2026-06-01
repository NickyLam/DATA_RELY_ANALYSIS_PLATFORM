/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_scss_unp_atm_tran_flow_scssi1
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
drop table ${iml_schema}.evt_scss_unp_atm_tran_flow_scssi1_tm purge;
alter table ${iml_schema}.evt_scss_unp_atm_tran_flow add partition p_scssi1 values ('scssi1')(
        subpartition p_scssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_scss_unp_atm_tran_flow modify partition p_scssi1
    add subpartition p_scssi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_scss_unp_atm_tran_flow_scssi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_dt -- 系统日期
    ,sys_flow_num -- 系统流水号
    ,req_flow_num -- 请求流水号
    ,aldy_revo_flg -- 已撤销标志
    ,revo_flow_num -- 撤销流水号
    ,revo_front_flow_num -- 撤销前置流水号
    ,chn_id -- 渠道编号
    ,src_chn_id -- 源渠道编号
    ,chn_dt -- 渠道日期
    ,check_entry_code -- 对账编码
    ,mercht_type_cd -- 商户类型代码
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,unionpay_org_id -- 银联机构编号
    ,unionpay_rg_code -- 银联地区码
    ,agent_org_id -- 代理机构编号
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,return_code -- 返回码
    ,return_descb -- 返回描述
    ,tran_flow_num -- 交易流水号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,init_intfc_code -- 原接口码
    ,tran_sub_module_code -- 交易子模块码
    ,tran_acct_id -- 交易账户编号
    ,tran_acct_name -- 交易账户名称
    ,tran_acct_type_cd -- 交易账户类型代码
    ,card_iss_org_id -- 发卡机构编号
    ,card_level_cd -- 卡片等级代码
    ,stl_card_flg -- 单位结算卡标志
    ,corp_stl_card_lp_name -- 单位结算卡法人姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_out_acct_org_id -- 转出账户机构编号
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,tran_in_acct_org_id -- 转入账户机构编号
    ,dr_acct_id1 -- 借方账户编号一
    ,dr_acct_name1 -- 借方账户名称一
    ,cr_acct_id1 -- 贷方账户编号一
    ,cr_acct_name1 -- 贷方账户名称一
    ,tran_amt1 -- 交易金额一
    ,dr_acct_id2 -- 借方账户编号二
    ,dr_acct_name2 -- 借方账户名称二
    ,cr_acct_id2 -- 贷方账户编号二
    ,cr_acct_name2 -- 贷方账户名称二
    ,tran_amt2 -- 交易金额二
    ,dr_acct_id3 -- 借方账户编号三
    ,dr_acct_name3 -- 借方账户名称三
    ,cr_acct_id3 -- 贷方账户编号三
    ,cr_acct_name3 -- 贷方账户名称三
    ,tran_amt3 -- 交易金额三
    ,dr_acct_id4 -- 借方账户编号四
    ,dr_acct_name4 -- 借方账户名称四
    ,cr_acct_id4 -- 贷方账户编号四
    ,cr_acct_name4 -- 贷方账户名称四
    ,tran_amt4 -- 交易金额四
    ,comm_fee_dr_acct_id -- 手续费借方账户编号
    ,comm_fee_dr_acct_name -- 手续费借方账户名称
    ,comm_fee_cr_acct_id -- 手续费贷方账户编号
    ,comm_fee_cr_acct_name -- 手续费贷方账户名称
    ,comm_fee_amt -- 手续费金额
    ,remark1 -- 手续费备注信息
    ,actl_bal -- 实际余额
    ,acct_bal -- 账户余额
    ,remark2 -- 闲钱宝备注信息
    ,serv_src_init_sys_id -- 服务源发起系统编号
    ,serv_target_sys_id -- 服务目标系统编号
    ,serv_msg_id -- 服务消息编号
    ,serv_caller_sys_id -- 服务调用方系统编号
    ,serv_ova_flow_num -- 服务全局流水号
    ,serv_caller_tran_flow_num -- 服务调用方交易流水号
    ,serv_caller_tran_dt -- 服务调用方交易日期
    ,serv_name -- 服务名称
    ,serv_tran_code -- 服务交易码
    ,tran_teller_id -- 交易柜员编号
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,core_return_code -- 核心返回码
    ,core_return_info -- 核心返回信息
    ,froz_dt -- 冻结日期
    ,froz_flow -- 冻结流水
    ,init_serv_caller_tran_flow_num -- 原服务调用方交易流水号
    ,init_serv_caller_tran_dt -- 原服务调用方交易日期
    ,init_upp_tran_flow_num -- 原UPP交易流水号
    ,init_upp_tran_dt -- 原UPP交易日期
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow_num -- 原冻结流水号
    ,cust_id -- 客户编号
    ,cust_belong_org_id -- 客户所属机构编号
    ,auth_flow_num -- 授权流水号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_serv_process_cd -- 交易服务处理码
    ,acctnt_dt -- 会计日期
    ,insto_dt -- 入库日期
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_scss_unp_atm_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- scss_tbl_n_txn-1
insert into ${iml_schema}.evt_scss_unp_atm_tran_flow_scssi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,sys_dt -- 系统日期
    ,sys_flow_num -- 系统流水号
    ,req_flow_num -- 请求流水号
    ,aldy_revo_flg -- 已撤销标志
    ,revo_flow_num -- 撤销流水号
    ,revo_front_flow_num -- 撤销前置流水号
    ,chn_id -- 渠道编号
    ,src_chn_id -- 源渠道编号
    ,chn_dt -- 渠道日期
    ,check_entry_code -- 对账编码
    ,mercht_type_cd -- 商户类型代码
    ,mercht_id -- 商户编号
    ,mercht_name -- 商户名称
    ,unionpay_org_id -- 银联机构编号
    ,unionpay_rg_code -- 银联地区码
    ,agent_org_id -- 代理机构编号
    ,tran_code -- 交易码
    ,tran_status_cd -- 交易状态代码
    ,return_code -- 返回码
    ,return_descb -- 返回描述
    ,tran_flow_num -- 交易流水号
    ,curr_cd -- 币种代码
    ,tran_amt -- 交易金额
    ,init_intfc_code -- 原接口码
    ,tran_sub_module_code -- 交易子模块码
    ,tran_acct_id -- 交易账户编号
    ,tran_acct_name -- 交易账户名称
    ,tran_acct_type_cd -- 交易账户类型代码
    ,card_iss_org_id -- 发卡机构编号
    ,card_level_cd -- 卡片等级代码
    ,stl_card_flg -- 单位结算卡标志
    ,corp_stl_card_lp_name -- 单位结算卡法人姓名
    ,cert_type_cd -- 证件类型代码
    ,cert_no -- 证件号码
    ,mobile_no -- 手机号码
    ,tran_out_acct_id -- 转出账户编号
    ,tran_out_acct_name -- 转出账户名称
    ,tran_out_acct_org_id -- 转出账户机构编号
    ,tran_in_acct_id -- 转入账户编号
    ,tran_in_acct_name -- 转入账户名称
    ,tran_in_acct_org_id -- 转入账户机构编号
    ,dr_acct_id1 -- 借方账户编号一
    ,dr_acct_name1 -- 借方账户名称一
    ,cr_acct_id1 -- 贷方账户编号一
    ,cr_acct_name1 -- 贷方账户名称一
    ,tran_amt1 -- 交易金额一
    ,dr_acct_id2 -- 借方账户编号二
    ,dr_acct_name2 -- 借方账户名称二
    ,cr_acct_id2 -- 贷方账户编号二
    ,cr_acct_name2 -- 贷方账户名称二
    ,tran_amt2 -- 交易金额二
    ,dr_acct_id3 -- 借方账户编号三
    ,dr_acct_name3 -- 借方账户名称三
    ,cr_acct_id3 -- 贷方账户编号三
    ,cr_acct_name3 -- 贷方账户名称三
    ,tran_amt3 -- 交易金额三
    ,dr_acct_id4 -- 借方账户编号四
    ,dr_acct_name4 -- 借方账户名称四
    ,cr_acct_id4 -- 贷方账户编号四
    ,cr_acct_name4 -- 贷方账户名称四
    ,tran_amt4 -- 交易金额四
    ,comm_fee_dr_acct_id -- 手续费借方账户编号
    ,comm_fee_dr_acct_name -- 手续费借方账户名称
    ,comm_fee_cr_acct_id -- 手续费贷方账户编号
    ,comm_fee_cr_acct_name -- 手续费贷方账户名称
    ,comm_fee_amt -- 手续费金额
    ,remark1 -- 手续费备注信息
    ,actl_bal -- 实际余额
    ,acct_bal -- 账户余额
    ,remark2 -- 闲钱宝备注信息
    ,serv_src_init_sys_id -- 服务源发起系统编号
    ,serv_target_sys_id -- 服务目标系统编号
    ,serv_msg_id -- 服务消息编号
    ,serv_caller_sys_id -- 服务调用方系统编号
    ,serv_ova_flow_num -- 服务全局流水号
    ,serv_caller_tran_flow_num -- 服务调用方交易流水号
    ,serv_caller_tran_dt -- 服务调用方交易日期
    ,serv_name -- 服务名称
    ,serv_tran_code -- 服务交易码
    ,tran_teller_id -- 交易柜员编号
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,core_return_code -- 核心返回码
    ,core_return_info -- 核心返回信息
    ,froz_dt -- 冻结日期
    ,froz_flow -- 冻结流水
    ,init_serv_caller_tran_flow_num -- 原服务调用方交易流水号
    ,init_serv_caller_tran_dt -- 原服务调用方交易日期
    ,init_upp_tran_flow_num -- 原UPP交易流水号
    ,init_upp_tran_dt -- 原UPP交易日期
    ,init_froz_dt -- 原冻结日期
    ,init_froz_flow_num -- 原冻结流水号
    ,cust_id -- 客户编号
    ,cust_belong_org_id -- 客户所属机构编号
    ,auth_flow_num -- 授权流水号
    ,auth_teller_id -- 授权柜员编号
    ,check_teller_id -- 复核柜员编号
    ,tran_serv_process_cd -- 交易服务处理码
    ,acctnt_dt -- 会计日期
    ,insto_dt -- 入库日期
    ,final_update_dt -- 最后更新日期
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401035'||P1.SYS_SEQ_NUM||P1.SYS_DATE -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.dateformat_max2(P1.SYS_DATE) -- 系统日期
    ,P1.SYS_SEQ_NUM -- 系统流水号
    ,P1.MSGTYPE -- 请求流水号
    ,nvl(trim(P1.CANCEL_FLAG),'-') -- 已撤销标志
    ,P1.KEY_CANCEL -- 撤销流水号
    ,P1.CANCEL_SSN -- 撤销前置流水号
    ,nvl(trim(P1.CHANN_NUM),'0000') -- 渠道编号
    ,decode(P1.ORG_CHANN_NUM,' ','-','其他','-',P1.ORG_CHANN_NUM) -- 源渠道编号
    ,${iml_schema}.dateformat_max2(P1.CHALDATE) -- 渠道日期
    ,P1.CHECKCODE -- 对账编码
    ,nvl(trim(P1.MCHNT_TYPE),'-') -- 商户类型代码
    ,P1.MCHNT_ID -- 商户编号
    ,P1.MCHNT_NAME -- 商户名称
    ,P1.ACQINSID -- 银联机构编号
    ,P1.CITY_CODE -- 银联地区码
    ,P1.ACQ_INST_ID_CODE -- 代理机构编号
    ,P1.TXN_NUM -- 交易码
    ,nvl(trim(P1.TRANS_STATE),'-') -- 交易状态代码
    ,P1.RESP_CODE -- 返回码
    ,P1.RESP_DESC -- 返回描述
    ,P1.KEY_RSP -- 交易流水号
    ,nvl(trim(P1.CURRCY_CODE_STLM),'-') -- 币种代码
    ,to_number(nvl(trim(P1.AMT_TRANS),0)) -- 交易金额
    ,P1.ORG_BIZ_TXN -- 原接口码
    ,P1.TRANSTYP -- 交易子模块码
    ,P1.TXN_ACCT_NUM -- 交易账户编号
    ,P1.TXN_ACCT_NAME -- 交易账户名称
    ,nvl(trim(P1.TXN_ACC_TYPE),'-') -- 交易账户类型代码
    ,P1.TXN_ACCT_ISSCODE -- 发卡机构编号
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CARD_LEVEL END -- 卡片等级代码
    ,nvl(trim(P1.SETT_CARD_FLAG),'-') -- 单位结算卡标志
    ,P1.SETT_CARD_NAME -- 单位结算卡法人姓名
    ,nvl(trim(P1.CERT_TYPE),'0000') -- 证件类型代码
    ,P1.CERT_ID -- 证件号码
    ,P1.RES_CEPH_NUM -- 手机号码
    ,P1.OUT_ACCT_ID -- 转出账户编号
    ,P1.OUT_ACCT_NAME -- 转出账户名称
    ,P1.OUT_ACCT_ISSID -- 转出账户机构编号
    ,P1.IN_ACCT_ID -- 转入账户编号
    ,P1.IN_ACCT_NAME -- 转入账户名称
    ,P1.IN_ACCT_ISSID -- 转入账户机构编号
    ,P1.PYE_ACCT_ID1 -- 借方账户编号一
    ,P1.PYE_ACCTNAME1 -- 借方账户名称一
    ,P1.PYR_ACCTID1 -- 贷方账户编号一
    ,P1.PYR_ACCTNAME1 -- 贷方账户名称一
    ,to_number(nvl(trim(P1.PYE2PYR_AMT1),0)) -- 交易金额一
    ,P1.PYE_ACCT_ID2 -- 借方账户编号二
    ,P1.PYE_ACCT_NAME2 -- 借方账户名称二
    ,P1.PYR_ACCT_ID2 -- 贷方账户编号二
    ,P1.PYR_ACCT_NAME2 -- 贷方账户名称二
    ,to_number(nvl(trim(P1.PYE2PYR_AMT2),0)) -- 交易金额二
    ,P1.PYE_ACCT_ID3 -- 借方账户编号三
    ,P1.PYE_ACCT_NAME3 -- 借方账户名称三
    ,P1.PYR_ACCT_ID3 -- 贷方账户编号三
    ,P1.PYR_ACCT_NAME3 -- 贷方账户名称三
    ,to_number(nvl(trim(P1.PYE2PYR_AMT3),0)) -- 交易金额三
    ,P1.PYE_ACCT_ID4 -- 借方账户编号四
    ,P1.PYE_ACCT_NAME4 -- 借方账户名称四
    ,P1.PYR_ACCT_ID4 -- 贷方账户编号四
    ,P1.PYR_ACCT_NAME4 -- 贷方账户名称四
    ,to_number(nvl(trim(P1.PYE2PYR_AMT4),0)) -- 交易金额四
    ,P1.PYE_FEE_ACCT_ID -- 手续费借方账户编号
    ,P1.PYE_FEE_ACCT_NAME -- 手续费借方账户名称
    ,P1.PYR_FEE_ACCT_ID -- 手续费贷方账户编号
    ,P1.PYR_FEE_ACCT_NAME -- 手续费贷方账户名称
    ,to_number(nvl(trim(P1.TRAN_FEE_AMT),0)) -- 手续费金额
    ,P1.RESV1 -- 手续费备注信息
    ,0 -- 实际余额
    ,0 -- 账户余额
    ,P1.MISC6 -- 闲钱宝备注信息
    ,P1.SRV_SRC_SYSID -- 服务源发起系统编号
    ,P1.SRV_DEST_SYSID -- 服务目标系统编号
    ,P1.SRV_MSGID -- 服务消息编号
    ,P1.SRV_CLLPTY_SYSID -- 服务调用方系统编号
    ,P1.SVR_GLOB_SEQNO -- 服务全局流水号
    ,P1.SVR_SOU_SEQNO -- 服务调用方交易流水号
    ,${iml_schema}.dateformat_max2(P1.SVR_SOU_DATE||P1.SVR_SOU_TIME) -- 服务调用方交易日期
    ,P1.SVR_SRC_NAME -- 服务名称
    ,P1.SVR_SRC_NUM -- 服务交易码
    ,P1.TELL_NO -- 交易柜员编号
    ,P1.UPPNO -- 核心流水号
    ,${iml_schema}.dateformat_max2(P1.UPPDATE) -- 核心日期
    ,P1.UPPCODE -- 核心返回码
    ,P1.UPPTXT -- 核心返回信息
    ,${iml_schema}.dateformat_max2(P1.COLDDATE) -- 冻结日期
    ,P1.COLDNUM -- 冻结流水
    ,P1.ORISOUSEQNO -- 原服务调用方交易流水号
    ,${iml_schema}.dateformat_max2(P1.ORISOUDATE||P1.ORISOUTIME) -- 原服务调用方交易日期
    ,P1.ORIUPPNO -- 原UPP交易流水号
    ,${iml_schema}.dateformat_max2(P1.ORIUPPDATE) -- 原UPP交易日期
    ,${iml_schema}.dateformat_max2(P1.ORICOLDDATE) -- 原冻结日期
    ,P1.ORICOLDNUM -- 原冻结流水号
    ,P1.PTYID -- 客户编号
    ,P1.PTYBRNO -- 客户所属机构编号
    ,P1.AUTHSEQNO -- 授权流水号
    ,P1.AUTHTELID -- 授权柜员编号
    ,P1.CHKTELID -- 复核柜员编号
    ,P1.PRCSCD -- 交易服务处理码
    ,${iml_schema}.dateformat_max2(P1.MISC1) -- 会计日期
    ,${iml_schema}.dateformat_min(P1.INST_DATE) -- 入库日期
    ,${iml_schema}.dateformat_max2(P1.UPDT_DATE) -- 最后更新日期
    ,P1.MISC3 -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'scss_tbl_n_txn' -- 源表名称
    ,'scssi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
  from ${iol_schema}.scss_tbl_n_txn p1
  left join ${iml_schema}.ref_pub_cd_map r1
    on p1.card_level = r1.src_code_val
   and r1.sorc_sys_cd = 'SCSS'
   and r1.src_tab_en_name = 'SCSS_TBL_N_TXN'
   and r1.src_field_en_name = 'CARD_LEVEL'
   and r1.target_tab_en_name = 'EVT_SCSS_UNP_ATM_TRAN_FLOW'
   and r1.target_tab_field_en_name = 'CARD_LEVEL_CD'
where  1 = 1 
    and p1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_scss_unp_atm_tran_flow truncate subpartition p_scssi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_scss_unp_atm_tran_flow exchange subpartition p_scssi1_${batch_date} with table ${iml_schema}.evt_scss_unp_atm_tran_flow_scssi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_scss_unp_atm_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_scss_unp_atm_tran_flow_scssi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_scss_unp_atm_tran_flow', partname => 'p_scssi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);