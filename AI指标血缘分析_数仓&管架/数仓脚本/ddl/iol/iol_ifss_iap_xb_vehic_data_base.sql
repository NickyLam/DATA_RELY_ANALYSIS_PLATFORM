/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifss_iap_xb_vehic_data_base
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifss_iap_xb_vehic_data_base
whenever sqlerror continue none;
drop table ${iol_schema}.ifss_iap_xb_vehic_data_base purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifss_iap_xb_vehic_data_base(
    ivb_create_time varchar2(30) -- 进件时间
    ,ivb_cust_no varchar2(60) -- 客户号
    ,ivb_cust_name varchar2(200) -- 客户名称
    ,ivb_order_no varchar2(60) -- 订单号
    ,ivb_stru_data_id_1 varchar2(60) -- 行驶证结构化文件id
    ,ivb_frame_no_1 varchar2(60) -- 车架号_行驶证结构化数据
    ,ivb_plate_no_1 varchar2(30) -- 车牌号_行驶证结构化数据
    ,ivb_owner varchar2(200) -- 车主
    ,ivb_poli_start_dt varchar2(500) -- 保单起始日期
    ,ivb_poli_end_dt varchar2(500) -- 保单终止日期
    ,ivb_insu_comp_name_1 varchar2(200) -- 保险公司
    ,ivb_blip_data_id_1 varchar2(60) -- 行驶证影像文件id
    ,ivb_blip_flag_1 varchar2(10) -- 行驶证影像件标志：0-否，1-是
    ,ivb_sys_check_flg_1 varchar2(10) -- 行驶证系统校验标志：0-否，1-是
    ,ivb_manu_check_flg_1 varchar2(10) -- 行驶证人工复核标志：0-否，1-是
    ,ivb_insure_form_flg varchar2(10) -- 投保单标志：0-无，1-有
    ,ivb_pay_advi_flg varchar2(10) -- 缴费通知单标志：0-无，1-有
    ,ivb_dubil_no varchar2(60) -- 借据号
    ,ivb_distr_dt varchar2(10) -- 放款日期
    ,ivb_exp_dt varchar2(10) -- 到期日期
    ,ivb_dubil_amt number(18,2) -- 放款金额
    ,ivb_dubil_bal number(18,2) -- 借据余额
    ,ivb_blip_data_id_2 varchar2(60) -- 保单影像文件id
    ,ivb_blip_flag_2 varchar2(10) -- 保单影像件标志：0-否，1-是
    ,ivb_sys_check_flg_2 varchar2(10) -- 保单系统校验标志：0-否，1-是
    ,ivb_manu_check_flg_2 varchar2(10) -- 保单人工复核标志：0-否，1-是
    ,ivb_poli_send_flg varchar2(10) -- 保单推送标志：0-未推送，1-已推送
    ,ivb_surder_flg varchar2(10) -- 退保标志：0-否，1-是
    ,ivb_surder_dt varchar2(10) -- 退保日期
    ,ivb_stru_data_id_2 varchar2(60) -- 保单结构化文件id
    ,ivb_poli_name varchar2(1000) -- 保单名称
    ,ivb_insu_comp_name_2 varchar2(200) -- 保险公司名称
    ,ivb_poli_num varchar2(100) -- 保单号
    ,ivb_insrt varchar2(200) -- 被保险人
    ,ivb_plate_no_2 varchar2(30) -- 车牌号_保单结构化数据
    ,ivb_frame_no_2 varchar2(60) -- 车架号_保单结构化数据
    ,ivb_engine_no varchar2(200) -- 发动机号码
    ,ivb_insure_pre_tot varchar2(500) -- 保险费合计
    ,ivb_insure_duran varchar2(500) -- 保险期间
    ,ivb_use_char varchar2(1000) -- 使用性质
    ,ivb_vehic_kind varchar2(1000) -- 机动车种类
    ,ivb_vehic_loss_insure varchar2(1000) -- 机动车损失保险
    ,ivb_vehic_trd_duty_insure varchar2(1000) -- 机动车第三者责任保险
    ,ivb_insrt_sign varchar2(1000) -- 保险人签章
    ,ivb_insrt_comp_name varchar2(1000) -- 保险人公司名称
    ,ivb_insrt_cert_no varchar2(30) -- 被保险人证件号码
    ,ivb_lab_model varchar2(1000) -- 厂牌型号
    ,ivb_cons_verifi_flg varchar2(10) -- 一致性验真标志：0-待验真，1-验真成功，2-验真失败，3-验真异常
    ,ivb_base_verifi_flg varchar2(10) -- 基础验真标志：0-待验真，1-验真成功，2-验真失败，3-验真异常
    ,ivb_occu_flg varchar2(10) -- 占用标志（默认0）：0-否，1-是
    ,ivb_etl_dt varchar2(10) -- ETL日期
    ,ivb_covered_flg varchar2(10) -- 承保标志：0-否，1-是
    ,ivb_notcover_msg varchar2(1000) -- 未承保原因
    ,ivb_order_fk varchar2(60) -- 订单外键：LOAN_USE_ORDER.LUO_ID
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifss_iap_xb_vehic_data_base to ${iml_schema};
grant select on ${iol_schema}.ifss_iap_xb_vehic_data_base to ${icl_schema};
grant select on ${iol_schema}.ifss_iap_xb_vehic_data_base to ${idl_schema};
grant select on ${iol_schema}.ifss_iap_xb_vehic_data_base to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifss_iap_xb_vehic_data_base is '信保车辆数据基表';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_create_time is '进件时间';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_cust_no is '客户号';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_cust_name is '客户名称';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_order_no is '订单号';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_stru_data_id_1 is '行驶证结构化文件id';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_frame_no_1 is '车架号_行驶证结构化数据';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_plate_no_1 is '车牌号_行驶证结构化数据';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_owner is '车主';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_poli_start_dt is '保单起始日期';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_poli_end_dt is '保单终止日期';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_insu_comp_name_1 is '保险公司';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_blip_data_id_1 is '行驶证影像文件id';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_blip_flag_1 is '行驶证影像件标志：0-否，1-是';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_sys_check_flg_1 is '行驶证系统校验标志：0-否，1-是';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_manu_check_flg_1 is '行驶证人工复核标志：0-否，1-是';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_insure_form_flg is '投保单标志：0-无，1-有';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_pay_advi_flg is '缴费通知单标志：0-无，1-有';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_dubil_no is '借据号';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_distr_dt is '放款日期';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_exp_dt is '到期日期';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_dubil_amt is '放款金额';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_dubil_bal is '借据余额';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_blip_data_id_2 is '保单影像文件id';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_blip_flag_2 is '保单影像件标志：0-否，1-是';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_sys_check_flg_2 is '保单系统校验标志：0-否，1-是';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_manu_check_flg_2 is '保单人工复核标志：0-否，1-是';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_poli_send_flg is '保单推送标志：0-未推送，1-已推送';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_surder_flg is '退保标志：0-否，1-是';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_surder_dt is '退保日期';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_stru_data_id_2 is '保单结构化文件id';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_poli_name is '保单名称';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_insu_comp_name_2 is '保险公司名称';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_poli_num is '保单号';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_insrt is '被保险人';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_plate_no_2 is '车牌号_保单结构化数据';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_frame_no_2 is '车架号_保单结构化数据';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_engine_no is '发动机号码';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_insure_pre_tot is '保险费合计';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_insure_duran is '保险期间';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_use_char is '使用性质';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_vehic_kind is '机动车种类';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_vehic_loss_insure is '机动车损失保险';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_vehic_trd_duty_insure is '机动车第三者责任保险';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_insrt_sign is '保险人签章';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_insrt_comp_name is '保险人公司名称';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_insrt_cert_no is '被保险人证件号码';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_lab_model is '厂牌型号';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_cons_verifi_flg is '一致性验真标志：0-待验真，1-验真成功，2-验真失败，3-验真异常';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_base_verifi_flg is '基础验真标志：0-待验真，1-验真成功，2-验真失败，3-验真异常';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_occu_flg is '占用标志（默认0）：0-否，1-是';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_etl_dt is 'ETL日期';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_covered_flg is '承保标志：0-否，1-是';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_notcover_msg is '未承保原因';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.ivb_order_fk is '订单外键：LOAN_USE_ORDER.LUO_ID';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifss_iap_xb_vehic_data_base.etl_timestamp is 'ETL处理时间戳';
