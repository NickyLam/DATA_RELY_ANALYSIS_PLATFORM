/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_scps_corp_bus_flow_scpsi1
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
drop table ${iml_schema}.evt_scps_corp_bus_flow_scpsi1_tm purge;
alter table ${iml_schema}.evt_scps_corp_bus_flow add partition p_scpsi1 values ('scpsi1')(
        subpartition p_scpsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_scps_corp_bus_flow modify partition p_scpsi1
    add subpartition p_scpsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_scps_corp_bus_flow_scpsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,ova_flow_num -- 全局流水号
    ,cust_open_acct_dt -- 客户开户日期
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,open_acct_status_cd -- 开户状态代码
    ,temp_acct_valid_dt -- 临时户有效日期
    ,super_corp_name -- 上级单位名称
    ,super_director_cert_type_cd -- 上级主管证件类型代码
    ,super_director_cert_no -- 上级主管证件号码
    ,depositr_name -- 存款人名称
    ,pre_proc_id -- 预受理编号
    ,fst_proof_doc_type_cd -- 第一证明文件类型代码
    ,fst_proof_doc_id -- 第一证明文件编号
    ,fst_proof_doc_exp_dt -- 第一证明文件到期日期
    ,fst_cert_type_cd -- 第一证件类型代码
    ,bus_flow_set -- 业务流程设置
    ,sign_mobile_no -- 签约手机号码
    ,bkcp_seal_way_cd -- 银企验印方式代码
    ,post_addr_desc -- 邮寄地址描述
    ,bkcp_zip_cd -- 银企邮政编码
    ,bkcp_cotas -- 银企联系人
    ,bkcp_phone_num -- 银企联系电话号码
    ,bkcp_check_entry_way_cd -- 银企对账方式代码
    ,bkcp_check_entry_ped_cd -- 银企对账周期代码
    ,y_acm_lmt -- 年累计限额
    ,daily_accum_lmt -- 日累计限额
    ,daily_accum_cnt -- 日累计笔数
    ,basic_serv_appl_type_cd -- 基本服务申请类型代码
    ,verify_type_cd -- 查证类型代码
    ,checker_seq_num -- 查证人序号
    ,cap_verify_teller_id -- 资金查证柜员编号
    ,legal_rep_mobile_no -- 法定代表人手机号码
    ,legal_rep_fixline_tel_num -- 法定代表人固定电话号码
    ,fin_princ_name -- 财务负责人名称
    ,fin_princ_mobile_no -- 财务负责人手机号码
    ,fin_princ_fixline_tel_num -- 财务负责人固定电话号码
    ,org_name -- 机构名称
    ,org_addr -- 机构地址
    ,legal_rep_name -- 法定代表人名称
    ,main_acct_id -- 主账户编号
    ,corp_stop_pay_status_cd -- 对公止付状态代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,corp_acct_char_cd -- 对公账户性质代码
    ,visit_serv_flg -- 上门服务标志
    ,apprv_way_cd -- 核准方式代码
    ,acct_actv_idf_cd -- 账户激活标识代码
    ,corp_bus_type_cd -- 对公业务类型代码
    ,share_seal_flg -- 共用验印标志
    ,back_check_flg -- 倒验标志
    ,agent_flg -- 代理标志
    ,agent_name -- 代理人姓名
    ,agent_cert_type -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_tel_num -- 	代理人电话号码
    ,agent_cert_vp -- 	代理人证件有效期
    ,corp_proc_status_cd -- 对公处理状态代码
    ,cust_clos_acct_dt -- 客户销户日期
    ,double_remote_flg -- 双异地标志
    ,open_acct_chn_id -- 开户渠道编号
    ,check_teller_id -- 审核柜员编号
    ,blip_batch_no -- 影像批次号
    ,apprv_flg -- 核准标志
    ,rg_cd -- 地区代码
    ,rgst_cap_curr_cd -- 注册资金币种代码
    ,super_lp_org_cd -- 上级法人机构代码
    ,super_director_corp_post_type_cd -- 上级主管单位职务类型代码
    ,recd_type_cd -- 备案类型代码
    ,backup_cmplt_flg -- 事后补扫完成标志
    ,pass_rapvrfction_flg -- 经过rpa核查标志
    ,bus_lics_found_dt -- 营业执照成立日期
    ,acct_name --账户名称
    ,rgst_addr --注册地址
    ,work_addr --办公地址
    ,mang_range_descb --经营范围描述
    ,dist_cd --行政区划代码
    ,rgst_cap --注册资本
    ,legal_rep_cert_no --法定代表人证件号码
    ,legal_rep_cert_type_cd --法定代表人证件类型代码
    ,acct_open_acct_lics_apprv_num --法定代表人基本存款账户开户许可证核准号
    ,depositr_cate_cd --存款人类别代码
    ,cust_mgr_teller_id --客户经理柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_scps_corp_bus_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- scps_bp_corporate_tb-1
insert into ${iml_schema}.evt_scps_corp_bus_flow_scpsi1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,task_no -- 任务号
    ,ova_flow_num -- 全局流水号
    ,cust_open_acct_dt -- 客户开户日期
    ,org_id -- 机构编号
    ,teller_id -- 柜员编号
    ,open_acct_status_cd -- 开户状态代码
    ,temp_acct_valid_dt -- 临时户有效日期
    ,super_corp_name -- 上级单位名称
    ,super_director_cert_type_cd -- 上级主管证件类型代码
    ,super_director_cert_no -- 上级主管证件号码
    ,depositr_name -- 存款人名称
    ,pre_proc_id -- 预受理编号
    ,fst_proof_doc_type_cd -- 第一证明文件类型代码
    ,fst_proof_doc_id -- 第一证明文件编号
    ,fst_proof_doc_exp_dt -- 第一证明文件到期日期
    ,fst_cert_type_cd -- 第一证件类型代码
    ,bus_flow_set -- 业务流程设置
    ,sign_mobile_no -- 签约手机号码
    ,bkcp_seal_way_cd -- 银企验印方式代码
    ,post_addr_desc -- 邮寄地址描述
    ,bkcp_zip_cd -- 银企邮政编码
    ,bkcp_cotas -- 银企联系人
    ,bkcp_phone_num -- 银企联系电话号码
    ,bkcp_check_entry_way_cd -- 银企对账方式代码
    ,bkcp_check_entry_ped_cd -- 银企对账周期代码
    ,y_acm_lmt -- 年累计限额
    ,daily_accum_lmt -- 日累计限额
    ,daily_accum_cnt -- 日累计笔数
    ,basic_serv_appl_type_cd -- 基本服务申请类型代码
    ,verify_type_cd -- 查证类型代码
    ,checker_seq_num -- 查证人序号
    ,cap_verify_teller_id -- 资金查证柜员编号
    ,legal_rep_mobile_no -- 法定代表人手机号码
    ,legal_rep_fixline_tel_num -- 法定代表人固定电话号码
    ,fin_princ_name -- 财务负责人名称
    ,fin_princ_mobile_no -- 财务负责人手机号码
    ,fin_princ_fixline_tel_num -- 财务负责人固定电话号码
    ,org_name -- 机构名称
    ,org_addr -- 机构地址
    ,legal_rep_name -- 法定代表人名称
    ,main_acct_id -- 主账户编号
    ,corp_stop_pay_status_cd -- 对公止付状态代码
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,corp_acct_char_cd -- 对公账户性质代码
    ,visit_serv_flg -- 上门服务标志
    ,apprv_way_cd -- 核准方式代码
    ,acct_actv_idf_cd -- 账户激活标识代码
    ,corp_bus_type_cd -- 对公业务类型代码
    ,share_seal_flg -- 共用验印标志
    ,back_check_flg -- 倒验标志
    ,agent_flg -- 代理标志
    ,agent_name -- 代理人姓名
    ,agent_cert_type -- 代理人证件类型代码
    ,agent_cert_no -- 代理人证件号码
    ,agent_tel_num -- 	代理人电话号码
    ,agent_cert_vp -- 	代理人证件有效期
    ,corp_proc_status_cd -- 对公处理状态代码
    ,cust_clos_acct_dt -- 客户销户日期
    ,double_remote_flg -- 双异地标志
    ,open_acct_chn_id -- 开户渠道编号
    ,check_teller_id -- 审核柜员编号
    ,blip_batch_no -- 影像批次号
    ,apprv_flg -- 核准标志
    ,rg_cd -- 地区代码
    ,rgst_cap_curr_cd -- 注册资金币种代码
    ,super_lp_org_cd -- 上级法人机构代码
    ,super_director_corp_post_type_cd -- 上级主管单位职务类型代码
    ,recd_type_cd -- 备案类型代码
    ,backup_cmplt_flg -- 事后补扫完成标志
    ,pass_rapvrfction_flg -- 经过rpa核查标志
    ,bus_lics_found_dt -- 营业执照成立日期
    ,acct_name --账户名称
    ,rgst_addr --注册地址
    ,work_addr --办公地址
    ,mang_range_descb --经营范围描述
    ,dist_cd --行政区划代码
    ,rgst_cap --注册资本
    ,legal_rep_cert_no --法定代表人证件号码
    ,legal_rep_cert_type_cd --法定代表人证件类型代码
    ,acct_open_acct_lics_apprv_num --法定代表人基本存款账户开户许可证核准号
    ,depositr_cate_cd --存款人类别代码
    ,cust_mgr_teller_id --客户经理柜员编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '201017 '||P1.TASK_ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.TASK_ID -- 任务号
    ,P1.GLOB_SEQ_NUM -- 全局流水号
    ,${iml_schema}.dateformat_max(P1.ACCT_OPEN_DATE) -- 客户开户日期
    ,P1.ORGAN_NO -- 机构编号
    ,P1.USER_NO -- 柜员编号
    ,P1.USER_ENABLE -- 开户状态代码
    ,${iml_schema}.dateformat_max(P1.EA_TEMPACCTDT_END) -- 临时户有效日期
    ,P1.EA_UPCRNA -- 上级单位名称
    ,P1.EA_F_COMPANY_FIN_PAPTYPE -- 上级主管证件类型代码
    ,P1.EA_F_COMPANY_FIN_PAPNO -- 上级主管证件号码
    ,P1.EA_DEPOSIT_NAME -- 存款人名称
    ,P1.EA_PRE_SEQNO -- 预受理编号
    ,P1.EA_PERPERS_INVAL_TYPE1 -- 第一证明文件类型代码
    ,P1.EA_PERPERS_INVAL_CODE1 -- 第一证明文件编号
    ,${iml_schema}.dateformat_max(P1.EA_PERPERS_INVAL_DATE1) -- 第一证明文件到期日期
    ,P1.EA_PAPERS_TYPE -- 第一证件类型代码
    ,P1.EI_BUSINESS_FLOW -- 业务流程设置
    ,P1.EI_SIGN_MOBILE -- 签约手机号码
    ,P1.EI_SEAL_MODE -- 银企验印方式代码
    ,P1.EI_MAIL_ADDRESS -- 邮寄地址描述
    ,P1.EI_BCZIPCD -- 银企邮政编码
    ,P1.EI_LINKMAN -- 银企联系人
    ,P1.EI_LINKTEL -- 银企联系电话号码
    ,P1.EI_SENDMODE -- 银企对账方式代码
    ,P1.EI_ACCCYCLE -- 银企对账周期代码
    ,nvl(regexp_substr(P1.EI_YEAR_LIMIT, '[0-9.]+'),'') -- 年累计限额
    ,nvl(regexp_substr(P1.EI_DAY_LIMIT, '[0-9.]+'),'') -- 日累计限额
    ,nvl(regexp_substr(P1.EI_DAY_TIMES, '[0-9.]+'),'') -- 日累计笔数
    ,P1.EI_APPLICATION -- 基本服务申请类型代码
    ,P1.EI_CALL_TYPE -- 查证类型代码
    ,P1.EI_PRINCIPAL_CHECKORDER -- 查证人序号
    ,P1.EI_PRINCIPAL_FUNDS_CHECK -- 资金查证柜员编号
    ,P1.EI_ACCREDIT_LEGAL_TEL -- 法定代表人手机号码
    ,P1.EI_ACCREDIT_LEGAL_PHONE -- 法定代表人固定电话号码
    ,P1.EI_MAINFIN_CONTECT_NAME -- 财务负责人名称
    ,P1.EI_MAINFIN_CONTECT_TEL -- 财务负责人手机号码
    ,P1.EI_MAINFIN_CONTECT_PHONE -- 财务负责人固定电话号码
    ,P1.EM_ORGANIZE_NAME -- 机构名称
    ,P1.EM_ORGANIZE_ADDRESS -- 机构地址
    ,P1.EA_LEGAL_REP -- 法定代表人名称
    ,P1.ES_MAIN_ACCOUNT -- 主账户编号
    ,P1.FROZEN_FLAG -- 对公止付状态代码
    ,P1.ACCT_NO -- 账户编号
    ,P1.CUST_NO -- 客户编号
    ,P1.CUST_NAME -- 客户名称
    ,'' -- 对公账户性质代码
    ,nvl(trim(P1.VISIT_SERVICE),0) -- 上门服务标志
    ,P1.CHECK_TYPE -- 核准方式代码
    ,P1.ACCOUNT_ACTIVE_FLAG -- 账户激活标识代码
    ,P1.BUSINESS_TYPE -- 对公业务类型代码
    ,P1.IF_PUBLIC_SEAL -- 共用验印标志
    ,P1.IF_SEAL -- 倒验标志
    ,P1.IS_PROXY -- 代理标志
    ,P1.PROXY_NAME -- 代理人姓名
    ,P1.PROXY_PAPERS_TYPE -- 代理人证件类型代码
    ,P1.PROXY_PAPERS_NUMBER -- 代理人证件号码
    ,P1.PROXY_PHONE -- 	代理人电话号码
    ,${iml_schema}.dateformat_max(P1.PROXY_INVALDT) -- 	代理人证件有效期
    ,P1.TRANS_STATE -- 对公处理状态代码
    ,${iml_schema}.dateformat_max(P1.ACCT_CANCEL_DATE) -- 客户销户日期
    ,P1.IS_LOCAL_CHECK -- 双异地标志
    ,P1.ACCT_OPEN_CHANNEL -- 开户渠道编号
    ,P1.CHARGE_ID -- 审核柜员编号
    ,P1.DOC_ID -- 影像批次号
    ,P1.IS_CHECK -- 核准标志
    ,P1.ZONE_CD -- 地区代码
    ,P1.REG_CAP_CCY -- 注册资金币种代码
    ,'' -- 上级法人机构代码
    ,P1.DIRT_UNT_LP_TYP -- 上级主管单位职务类型代码
    ,P1.REC_TYPE -- 备案类型代码
    ,P1.IS_BS_FLAG -- 事后补扫完成标志
    ,P1.IS_RPA_CHECK -- 经过rpa核查标志
    ,${iml_schema}.dateformat_max(P1.FOUND_DATE) -- 营业执照成立日期
    ,P1.EA_ACCT_NAME --账户名称
    ,P1.EA_REGISTER_ADDRESS --注册地址
    ,P1.EA_WORK_ADDRESS --办公地址
    ,P1.EA_OPERATE_SCOPE --经营范围描述
    ,nvl(trim(P1.PEOPLE_AREA_CODE),'000000') --行政区划代码
    ,P1.EA_REGISTER_FUND --注册资本
    ,P1.EA_COMPANY_FIN_PAPNO --法定代表人证件号码
    ,nvl(trim(P1.EA_COMPANY_FIN_PAPTYPE),'0000') --法定代表人证件类型代码
    ,P1.EA_CERTCODE --法定代表人基本存款账户开户许可证核准号
    ,nvl(trim(P1.EA_DEPOSIT_TYPE),'299') --存款人类别代码
    ,P1.EA_ATTOR_OPRNO --客户经理柜员编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'scps_bp_corporate_tb' -- 源表名称
    ,'scpsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.scps_bp_corporate_tb p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_scps_corp_bus_flow truncate subpartition p_scpsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_scps_corp_bus_flow exchange subpartition p_scpsi1_${batch_date} with table ${iml_schema}.evt_scps_corp_bus_flow_scpsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_scps_corp_bus_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_scps_corp_bus_flow_scpsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_scps_corp_bus_flow', partname => 'p_scpsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);