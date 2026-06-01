/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_tips_realtm_batch_tax_req_dtl_mpcsf1
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
drop table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl_mpcsf1_tm purge;
alter table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl_mpcsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dt -- 登记日期
    ,rgst_flow_num -- 登记流水号
    ,tran_org_id -- 交易机构编号
    ,impose_org_id -- 征收机关编号
    ,impose_org_name -- 征收机关名称
    ,entr_dt -- 委托日期
    ,tran_flow_num -- 交易流水号
    ,coll_cate_cd -- 经收类别代码
    ,recv_bank_bank_no -- 收款行行号
    ,recvbl_corp_id -- 收款单位编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_corp_name -- 收款单位名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_open_bank_no -- 付款开户行行号
    ,pay_acct_id -- 付款账户编号
    ,pay_corp_name -- 缴款单位名称
    ,tran_amt -- 交易金额
    ,proc_status_cd -- 处理状态代码
    ,tax_bill_id -- 税票编号
    ,taxpayer_name -- 纳税人名称
    ,agt_id -- 协议编号
    ,check_entry_type_descb -- 对账类型描述
    ,tax_category_cnt -- 税种条数
    ,tax_dt -- 扣税日期
    ,rest_code -- 处理结果编码
    ,rtn_rcpt_postsc -- 回执附言
    ,acpt_proc_tm -- 接受处理时间
    ,check_entry_status_cd -- 对账状态代码
    ,is_print_flg -- 是否打印标志
    ,tran_type_cd -- 交易类型代码
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,host_check_entry_status_cd -- 主机对账状态代码
    ,mode_pay_cd -- 支付方式代码
    ,taxpayer_idtfy_id -- 纳税人识别编号
    ,vouch_id -- 凭证编号
    ,check_entry_type_cd -- 对账类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- mpcs_a0dtps_rtrq-
insert into ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl_mpcsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,rgst_dt -- 登记日期
    ,rgst_flow_num -- 登记流水号
    ,tran_org_id -- 交易机构编号
    ,impose_org_id -- 征收机关编号
    ,impose_org_name -- 征收机关名称
    ,entr_dt -- 委托日期
    ,tran_flow_num -- 交易流水号
    ,coll_cate_cd -- 经收类别代码
    ,recv_bank_bank_no -- 收款行行号
    ,recvbl_corp_id -- 收款单位编号
    ,recvbl_acct_id -- 收款账户编号
    ,recvbl_corp_name -- 收款单位名称
    ,pay_bank_bank_no -- 付款行行号
    ,pay_open_bank_no -- 付款开户行行号
    ,pay_acct_id -- 付款账户编号
    ,pay_corp_name -- 缴款单位名称
    ,tran_amt -- 交易金额
    ,proc_status_cd -- 处理状态代码
    ,tax_bill_id -- 税票编号
    ,taxpayer_name -- 纳税人名称
    ,agt_id -- 协议编号
    ,check_entry_type_descb -- 对账类型描述
    ,tax_category_cnt -- 税种条数
    ,tax_dt -- 扣税日期
    ,rest_code -- 处理结果编码
    ,rtn_rcpt_postsc -- 回执附言
    ,acpt_proc_tm -- 接受处理时间
    ,check_entry_status_cd -- 对账状态代码
    ,is_print_flg -- 是否打印标志
    ,tran_type_cd -- 交易类型代码
    ,core_flow_num -- 核心流水号
    ,core_dt -- 核心日期
    ,host_check_entry_status_cd -- 主机对账状态代码
    ,mode_pay_cd -- 支付方式代码
    ,taxpayer_idtfy_id -- 纳税人识别编号
    ,vouch_id -- 凭证编号
    ,check_entry_type_cd -- 对账类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201018'||P1.SDTLSQ||P1.SDTLDT -- 事件编号
    ,'9999' -- 法人编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.SDTLDT) -- 登记日期
    ,P1.SDTLSQ -- 登记流水号
    ,P1.BRCHNO -- 交易机构编号
    ,P1.TXCODE -- 征收机关编号
    ,P1.TAXORGNAME -- 征收机关名称
    ,${iml_schema}.DATEFORMAT_MIN(P1.TIPSDT) -- 委托日期
    ,P1.TIPSSQ -- 交易流水号
    ,P1.HDTYPE -- 经收类别代码
    ,P1.RECVBK -- 收款行行号
    ,P1.RECVUT -- 收款单位编号
    ,P1.RECVAC -- 收款账户编号
    ,P1.RECVNA -- 收款单位名称
    ,P1.PYERBK -- 付款行行号
    ,P1.PYACBK -- 付款开户行行号
    ,P1.PYERAC -- 付款账户编号
    ,P1.PYUTNA -- 缴款单位名称
    ,P1.TRANAM -- 交易金额
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL 
     ELSE '@'||P1.TRANST
END -- 处理状态代码
    ,P1.TXVHNO -- 税票编号
    ,P1.TXUTNA -- 纳税人名称
    ,P1.CONTID -- 协议编号
    ,P1.REMAR1 -- 对账类型描述
    ,P1.LISTNM -- 税种条数
    ,${iml_schema}.DATEFORMAT_MAX(P1.TAXDAT) -- 扣税日期
    ,P1.RETNCD -- 处理结果编码
    ,P1.RTINFO -- 回执附言
    ,${iml_schema}.DATEFORMAT_MIN(P1.DEALTM) -- 接受处理时间
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL 
     ELSE '@'||P1.CHCKFG
END -- 对账状态代码
    ,P1.PRTFLG -- 是否打印标志
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL 
     ELSE '@'||P1.TRANTYPE
END -- 交易类型代码
    ,P1.HOSTNBR -- 核心流水号
    ,P1.HOSTDATE -- 核心日期
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL 
     ELSE '@'||P1.COLSTS
END -- 主机对账状态代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL 
     ELSE '@'||P1.PAYTYPE
END -- 支付方式代码
    ,P1.TXUTNAID -- 纳税人识别编号
    ,P1.BOOKSEQNO -- 凭证编号
    ,P1.CHCKTP -- 对账类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0dtps_rtrq' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0dtps_rtrq p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.TRANST = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'MPCS'
        AND R1.SRC_TAB_EN_NAME= 'MPCS_A0DTPS_RTRQ'
        AND R1.SRC_FIELD_EN_NAME= 'TRANST'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_TIPS_REALTM_BATCH_TAX_REQ_DTL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'PROC_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CHCKFG = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A0DTPS_RTRQ'
        AND R2.SRC_FIELD_EN_NAME= 'CHCKFG'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_TIPS_REALTM_BATCH_TAX_REQ_DTL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CHECK_ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRANTYPE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'MPCS'
        AND R3.SRC_TAB_EN_NAME= 'MPCS_A0DTPS_RTRQ'
        AND R3.SRC_FIELD_EN_NAME= 'TRANTYPE'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_TIPS_REALTM_BATCH_TAX_REQ_DTL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'TRAN_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.COLSTS = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'MPCS'
        AND R4.SRC_TAB_EN_NAME= 'MPCS_A0DTPS_RTRQ'
        AND R4.SRC_FIELD_EN_NAME= 'COLSTS'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_TIPS_REALTM_BATCH_TAX_REQ_DTL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'HOST_CHECK_ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.PAYTYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'MPCS'
        AND R5.SRC_TAB_EN_NAME= 'MPCS_A0DTPS_RTRQ'
        AND R5.SRC_FIELD_EN_NAME= 'PAYTYPE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_TIPS_REALTM_BATCH_TAX_REQ_DTL'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'MODE_PAY_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl truncate partition p_mpcsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl_mpcsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_tips_realtm_batch_tax_req_dtl_mpcsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_tips_realtm_batch_tax_req_dtl', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);