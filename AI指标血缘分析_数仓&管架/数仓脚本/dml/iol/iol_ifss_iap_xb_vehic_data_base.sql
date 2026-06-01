/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifss_iap_xb_vehic_data_base
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifss_iap_xb_vehic_data_base_ex purge;
alter table ${iol_schema}.ifss_iap_xb_vehic_data_base add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifss_iap_xb_vehic_data_base truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifss_iap_xb_vehic_data_base_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifss_iap_xb_vehic_data_base where 0=1;

insert /*+ append */ into ${iol_schema}.ifss_iap_xb_vehic_data_base_ex(
    ivb_create_time -- 进件时间
    ,ivb_cust_no -- 客户号
    ,ivb_cust_name -- 客户名称
    ,ivb_order_no -- 订单号
    ,ivb_stru_data_id_1 -- 行驶证结构化文件id
    ,ivb_frame_no_1 -- 车架号_行驶证结构化数据
    ,ivb_plate_no_1 -- 车牌号_行驶证结构化数据
    ,ivb_owner -- 车主
    ,ivb_poli_start_dt -- 保单起始日期
    ,ivb_poli_end_dt -- 保单终止日期
    ,ivb_insu_comp_name_1 -- 保险公司
    ,ivb_blip_data_id_1 -- 行驶证影像文件id
    ,ivb_blip_flag_1 -- 行驶证影像件标志：0-否，1-是
    ,ivb_sys_check_flg_1 -- 行驶证系统校验标志：0-否，1-是
    ,ivb_manu_check_flg_1 -- 行驶证人工复核标志：0-否，1-是
    ,ivb_insure_form_flg -- 投保单标志：0-无，1-有
    ,ivb_pay_advi_flg -- 缴费通知单标志：0-无，1-有
    ,ivb_dubil_no -- 借据号
    ,ivb_distr_dt -- 放款日期
    ,ivb_exp_dt -- 到期日期
    ,ivb_dubil_amt -- 放款金额
    ,ivb_dubil_bal -- 借据余额
    ,ivb_blip_data_id_2 -- 保单影像文件id
    ,ivb_blip_flag_2 -- 保单影像件标志：0-否，1-是
    ,ivb_sys_check_flg_2 -- 保单系统校验标志：0-否，1-是
    ,ivb_manu_check_flg_2 -- 保单人工复核标志：0-否，1-是
    ,ivb_poli_send_flg -- 保单推送标志：0-未推送，1-已推送
    ,ivb_surder_flg -- 退保标志：0-否，1-是
    ,ivb_surder_dt -- 退保日期
    ,ivb_stru_data_id_2 -- 保单结构化文件id
    ,ivb_poli_name -- 保单名称
    ,ivb_insu_comp_name_2 -- 保险公司名称
    ,ivb_poli_num -- 保单号
    ,ivb_insrt -- 被保险人
    ,ivb_plate_no_2 -- 车牌号_保单结构化数据
    ,ivb_frame_no_2 -- 车架号_保单结构化数据
    ,ivb_engine_no -- 发动机号码
    ,ivb_insure_pre_tot -- 保险费合计
    ,ivb_insure_duran -- 保险期间
    ,ivb_use_char -- 使用性质
    ,ivb_vehic_kind -- 机动车种类
    ,ivb_vehic_loss_insure -- 机动车损失保险
    ,ivb_vehic_trd_duty_insure -- 机动车第三者责任保险
    ,ivb_insrt_sign -- 保险人签章
    ,ivb_insrt_comp_name -- 保险人公司名称
    ,ivb_insrt_cert_no -- 被保险人证件号码
    ,ivb_lab_model -- 厂牌型号
    ,ivb_cons_verifi_flg -- 一致性验真标志：0-待验真，1-验真成功，2-验真失败，3-验真异常
    ,ivb_base_verifi_flg -- 基础验真标志：0-待验真，1-验真成功，2-验真失败，3-验真异常
    ,ivb_occu_flg -- 占用标志（默认0）：0-否，1-是
    ,ivb_etl_dt -- ETL日期
    ,ivb_covered_flg -- 承保标志：0-否，1-是
    ,ivb_notcover_msg -- 未承保原因
    ,ivb_order_fk -- 订单外键：LOAN_USE_ORDER.LUO_ID
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ivb_create_time -- 进件时间
    ,ivb_cust_no -- 客户号
    ,ivb_cust_name -- 客户名称
    ,ivb_order_no -- 订单号
    ,ivb_stru_data_id_1 -- 行驶证结构化文件id
    ,ivb_frame_no_1 -- 车架号_行驶证结构化数据
    ,ivb_plate_no_1 -- 车牌号_行驶证结构化数据
    ,ivb_owner -- 车主
    ,ivb_poli_start_dt -- 保单起始日期
    ,ivb_poli_end_dt -- 保单终止日期
    ,ivb_insu_comp_name_1 -- 保险公司
    ,ivb_blip_data_id_1 -- 行驶证影像文件id
    ,ivb_blip_flag_1 -- 行驶证影像件标志：0-否，1-是
    ,ivb_sys_check_flg_1 -- 行驶证系统校验标志：0-否，1-是
    ,ivb_manu_check_flg_1 -- 行驶证人工复核标志：0-否，1-是
    ,ivb_insure_form_flg -- 投保单标志：0-无，1-有
    ,ivb_pay_advi_flg -- 缴费通知单标志：0-无，1-有
    ,ivb_dubil_no -- 借据号
    ,ivb_distr_dt -- 放款日期
    ,ivb_exp_dt -- 到期日期
    ,ivb_dubil_amt -- 放款金额
    ,ivb_dubil_bal -- 借据余额
    ,ivb_blip_data_id_2 -- 保单影像文件id
    ,ivb_blip_flag_2 -- 保单影像件标志：0-否，1-是
    ,ivb_sys_check_flg_2 -- 保单系统校验标志：0-否，1-是
    ,ivb_manu_check_flg_2 -- 保单人工复核标志：0-否，1-是
    ,ivb_poli_send_flg -- 保单推送标志：0-未推送，1-已推送
    ,ivb_surder_flg -- 退保标志：0-否，1-是
    ,ivb_surder_dt -- 退保日期
    ,ivb_stru_data_id_2 -- 保单结构化文件id
    ,ivb_poli_name -- 保单名称
    ,ivb_insu_comp_name_2 -- 保险公司名称
    ,ivb_poli_num -- 保单号
    ,ivb_insrt -- 被保险人
    ,ivb_plate_no_2 -- 车牌号_保单结构化数据
    ,ivb_frame_no_2 -- 车架号_保单结构化数据
    ,ivb_engine_no -- 发动机号码
    ,ivb_insure_pre_tot -- 保险费合计
    ,ivb_insure_duran -- 保险期间
    ,ivb_use_char -- 使用性质
    ,ivb_vehic_kind -- 机动车种类
    ,ivb_vehic_loss_insure -- 机动车损失保险
    ,ivb_vehic_trd_duty_insure -- 机动车第三者责任保险
    ,ivb_insrt_sign -- 保险人签章
    ,ivb_insrt_comp_name -- 保险人公司名称
    ,ivb_insrt_cert_no -- 被保险人证件号码
    ,ivb_lab_model -- 厂牌型号
    ,ivb_cons_verifi_flg -- 一致性验真标志：0-待验真，1-验真成功，2-验真失败，3-验真异常
    ,ivb_base_verifi_flg -- 基础验真标志：0-待验真，1-验真成功，2-验真失败，3-验真异常
    ,ivb_occu_flg -- 占用标志（默认0）：0-否，1-是
    ,ivb_etl_dt -- ETL日期
    ,ivb_covered_flg -- 承保标志：0-否，1-是
    ,ivb_notcover_msg -- 未承保原因
    ,ivb_order_fk -- 订单外键：LOAN_USE_ORDER.LUO_ID
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifss_iap_xb_vehic_data_base
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifss_iap_xb_vehic_data_base exchange partition p_${batch_date} with table ${iol_schema}.ifss_iap_xb_vehic_data_base_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifss_iap_xb_vehic_data_base to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifss_iap_xb_vehic_data_base_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifss_iap_xb_vehic_data_base',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);