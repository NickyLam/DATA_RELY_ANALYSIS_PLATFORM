/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_evt_scps_corp_bus_flow
CreateDate: 20180515
Logs:
    luzd 2019-05-27 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_evt_scps_corp_bus_flow drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_evt_scps_corp_bus_flow drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_evt_scps_corp_bus_flow add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_evt_scps_corp_bus_flow partition for (to_date('${batch_date}','yyyymmdd')) (
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
    ,agent_tel_num -- 代理人电话号码
    ,agent_cert_vp -- 代理人证件有效期
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
    ,acct_name -- 账户名称
    ,rgst_addr -- 注册地址
    ,work_addr -- 办公地址
    ,mang_range_descb -- 经营范围描述
    ,dist_cd -- 行政区划代码
    ,rgst_cap -- 注册资本
    ,legal_rep_cert_no -- 法定代表人证件号码
    ,legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,acct_open_acct_lics_apprv_num -- 法定代表人基本存款账户开户许可证核准号
    ,depositr_cate_cd -- 存款人类别代码
    ,cust_mgr_teller_id -- 客户经理柜员编号
    --,src_table_name -- 源表名称
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(evt_id), ' ') as evt_id -- 事件编号
    ,nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(task_no), ' ') as task_no -- 任务号
    ,nvl(trim(ova_flow_num), ' ') as ova_flow_num -- 全局流水号
    ,nvl(cust_open_acct_dt, to_date('00010101', 'yyyymmdd')) as cust_open_acct_dt -- 客户开户日期
    ,nvl(trim(org_id), ' ') as org_id -- 机构编号
    ,nvl(trim(teller_id), ' ') as teller_id -- 柜员编号
    ,nvl(trim(open_acct_status_cd), ' ') as open_acct_status_cd -- 开户状态代码
    ,nvl(temp_acct_valid_dt, to_date('00010101', 'yyyymmdd')) as temp_acct_valid_dt -- 临时户有效日期
    ,nvl(trim(super_corp_name), ' ') as super_corp_name -- 上级单位名称
    ,nvl(trim(super_director_cert_type_cd), ' ') as super_director_cert_type_cd -- 上级主管证件类型代码
    ,nvl(trim(super_director_cert_no), ' ') as super_director_cert_no -- 上级主管证件号码
    ,nvl(trim(depositr_name), ' ') as depositr_name -- 存款人名称
    ,nvl(trim(pre_proc_id), ' ') as pre_proc_id -- 预受理编号
    ,nvl(trim(fst_proof_doc_type_cd), ' ') as fst_proof_doc_type_cd -- 第一证明文件类型代码
    ,nvl(trim(fst_proof_doc_id), ' ') as fst_proof_doc_id -- 第一证明文件编号
    ,nvl(fst_proof_doc_exp_dt, to_date('00010101', 'yyyymmdd')) as fst_proof_doc_exp_dt -- 第一证明文件到期日期
    ,nvl(trim(fst_cert_type_cd), ' ') as fst_cert_type_cd -- 第一证件类型代码
    ,nvl(trim(bus_flow_set), ' ') as bus_flow_set -- 业务流程设置
    ,nvl(trim(sign_mobile_no), ' ') as sign_mobile_no -- 签约手机号码
    ,nvl(trim(bkcp_seal_way_cd), ' ') as bkcp_seal_way_cd -- 银企验印方式代码
    ,nvl(trim(post_addr_desc), ' ') as post_addr_desc -- 邮寄地址描述
    ,nvl(trim(bkcp_zip_cd), ' ') as bkcp_zip_cd -- 银企邮政编码
    ,nvl(trim(bkcp_cotas), ' ') as bkcp_cotas -- 银企联系人
    ,nvl(trim(bkcp_phone_num), ' ') as bkcp_phone_num -- 银企联系电话号码
    ,nvl(trim(bkcp_check_entry_way_cd), ' ') as bkcp_check_entry_way_cd -- 银企对账方式代码
    ,nvl(trim(bkcp_check_entry_ped_cd), ' ') as bkcp_check_entry_ped_cd -- 银企对账周期代码
    ,nvl(trim(y_acm_lmt), 0) as y_acm_lmt -- 年累计限额
    ,nvl(trim(daily_accum_lmt), 0) as daily_accum_lmt -- 日累计限额
    ,nvl(trim(daily_accum_cnt), 0) as daily_accum_cnt -- 日累计笔数
    ,nvl(trim(basic_serv_appl_type_cd), ' ') as basic_serv_appl_type_cd -- 基本服务申请类型代码
    ,nvl(trim(verify_type_cd), ' ') as verify_type_cd -- 查证类型代码
    ,nvl(trim(checker_seq_num), ' ') as checker_seq_num -- 查证人序号
    ,nvl(trim(cap_verify_teller_id), ' ') as cap_verify_teller_id -- 资金查证柜员编号
    ,nvl(trim(legal_rep_mobile_no), ' ') as legal_rep_mobile_no -- 法定代表人手机号码
    ,nvl(trim(legal_rep_fixline_tel_num), ' ') as legal_rep_fixline_tel_num -- 法定代表人固定电话号码
    ,nvl(trim(fin_princ_name), ' ') as fin_princ_name -- 财务负责人名称
    ,nvl(trim(fin_princ_mobile_no), ' ') as fin_princ_mobile_no -- 财务负责人手机号码
    ,nvl(trim(fin_princ_fixline_tel_num), ' ') as fin_princ_fixline_tel_num -- 财务负责人固定电话号码
    ,nvl(trim(org_name), ' ') as org_name -- 机构名称
    ,nvl(trim(org_addr), ' ') as org_addr -- 机构地址
    ,nvl(trim(legal_rep_name), ' ') as legal_rep_name -- 法定代表人名称
    ,nvl(trim(main_acct_id), ' ') as main_acct_id -- 主账户编号
    ,nvl(trim(corp_stop_pay_status_cd), ' ') as corp_stop_pay_status_cd -- 对公止付状态代码
    ,nvl(trim(acct_id), ' ') as acct_id -- 账户编号
    ,nvl(trim(cust_id), ' ') as cust_id -- 客户编号
    ,nvl(trim(cust_name), ' ') as cust_name -- 客户名称
    ,nvl(trim(corp_acct_char_cd), ' ') as corp_acct_char_cd -- 对公账户性质代码
    ,nvl(trim(visit_serv_flg), 0) as visit_serv_flg -- 上门服务标志
    ,nvl(trim(apprv_way_cd), ' ') as apprv_way_cd -- 核准方式代码
    ,nvl(trim(acct_actv_idf_cd), ' ') as acct_actv_idf_cd -- 账户激活标识代码
    ,nvl(trim(corp_bus_type_cd), ' ') as corp_bus_type_cd -- 对公业务类型代码
    ,nvl(trim(share_seal_flg), ' ') as share_seal_flg -- 共用验印标志
    ,nvl(trim(back_check_flg), ' ') as back_check_flg -- 倒验标志
    ,nvl(trim(agent_flg), ' ') as agent_flg -- 代理标志
    ,nvl(trim(agent_name), ' ') as agent_name -- 代理人姓名
    ,nvl(trim(agent_cert_type), ' ') as agent_cert_type -- 代理人证件类型代码
    ,nvl(trim(agent_cert_no), ' ') as agent_cert_no -- 代理人证件号码
    ,nvl(trim(agent_tel_num), ' ') as agent_tel_num -- 代理人电话号码
    ,nvl(agent_cert_vp, to_date('00010101', 'yyyymmdd')) as agent_cert_vp -- 代理人证件有效期
    ,nvl(trim(corp_proc_status_cd), ' ') as corp_proc_status_cd -- 对公处理状态代码
    ,nvl(cust_clos_acct_dt, to_date('00010101', 'yyyymmdd')) as cust_clos_acct_dt -- 客户销户日期
    ,nvl(trim(double_remote_flg), ' ') as double_remote_flg -- 双异地标志
    ,nvl(trim(open_acct_chn_id), ' ') as open_acct_chn_id -- 开户渠道编号
    ,nvl(trim(check_teller_id), ' ') as check_teller_id -- 审核柜员编号
    ,nvl(trim(blip_batch_no), ' ') as blip_batch_no -- 影像批次号
    ,nvl(trim(apprv_flg), ' ') as apprv_flg -- 核准标志
    ,nvl(trim(rg_cd), ' ') as rg_cd -- 地区代码
    ,nvl(trim(rgst_cap_curr_cd), ' ') as rgst_cap_curr_cd -- 注册资金币种代码
    ,nvl(trim(super_lp_org_cd), ' ') as super_lp_org_cd -- 上级法人机构代码
    ,nvl(trim(super_director_corp_post_type_cd), ' ') as super_director_corp_post_type_cd -- 上级主管单位职务类型代码
    ,nvl(trim(recd_type_cd), ' ') as recd_type_cd -- 备案类型代码
    ,nvl(trim(backup_cmplt_flg), ' ') as backup_cmplt_flg -- 事后补扫完成标志
    ,nvl(trim(pass_rapvrfction_flg), ' ') as pass_rapvrfction_flg -- 经过rpa核查标志
    ,nvl(bus_lics_found_dt, to_date('00010101', 'yyyymmdd')) as bus_lics_found_dt -- 营业执照成立日期
    ,nvl(trim(acct_name), ' ') as acct_name -- 账户名称
    ,nvl(trim(rgst_addr), ' ') as rgst_addr -- 注册地址
    ,nvl(trim(work_addr), ' ') as work_addr -- 办公地址
    ,nvl(trim(mang_range_descb), ' ') as mang_range_descb -- 经营范围描述
    ,nvl(trim(dist_cd), ' ') as dist_cd -- 行政区划代码
    ,nvl(trim(rgst_cap), 0) as rgst_cap -- 注册资本
    ,nvl(trim(legal_rep_cert_no), ' ') as legal_rep_cert_no -- 法定代表人证件号码
    ,nvl(trim(legal_rep_cert_type_cd), ' ') as legal_rep_cert_type_cd -- 法定代表人证件类型代码
    ,nvl(trim(acct_open_acct_lics_apprv_num), ' ') as acct_open_acct_lics_apprv_num -- 法定代表人基本存款账户开户许可证核准号
    ,nvl(trim(depositr_cate_cd), ' ') as depositr_cate_cd -- 存款人类别代码
    ,nvl(trim(cust_mgr_teller_id), ' ') as cust_mgr_teller_id -- 客户经理柜员编号
    --,nvl(trim(src_table_name), ' ') as src_table_name -- 源表名称
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_evt_scps_corp_bus_flow
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_evt_scps_corp_bus_flow to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_evt_scps_corp_bus_flow',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);