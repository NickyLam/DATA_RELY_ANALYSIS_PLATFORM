/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_bank_card_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_bank_card_basic_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_bank_card_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_bank_card_basic_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,card_no varchar2(60) -- 卡号
    ,card_bin varchar2(60) -- 卡BIN
    ,main_card_card_no varchar2(60) -- 主卡卡号
    ,vouch_no varchar2(60) -- 凭证号码
    ,vouch_mgmt_id varchar2(60) -- 凭证管理编号
    ,nc_card_no varchar2(60) -- 无校验位卡号
    ,magt_ctrl_id varchar2(500) -- 写磁控制编号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,card_name varchar2(90) -- 卡名称
    ,cust_id varchar2(60) -- 客户编号
    ,start_use_flg varchar2(10) -- 启用标志
    ,vtual_card_flg varchar2(10) -- 虚拟卡标志
    ,main_card_flg varchar2(10) -- 主卡标志
    ,corp_stl_card_flg varchar2(10) -- 单位结算卡标志
    ,card_psbook_merge_one_flg varchar2(10) -- 卡折合一标志
    ,nomi_card_flg varchar2(10) -- 记名卡标志
    ,vouch_kind_cd varchar2(10) -- 凭证种类代码
    ,card_type_cd varchar2(10) -- 卡种类代码
    ,co_card_type_cd varchar2(10) -- 合作卡类型代码
    ,card_status_cd varchar2(10) -- 卡状态代码
    ,card_level_cd varchar2(10) -- 卡等级代码
    ,make_card_appl_id varchar2(50) -- 制卡申请编号
    ,make_card_flow_num varchar2(60) -- 制卡流水号
    ,make_card_dt date -- 制卡日期
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,invalid_dt_pwd varchar2(100) -- 失效日期密文
    ,card_iss_org_id varchar2(60) -- 发卡机构编号
    ,card_iss_teller_id varchar2(60) -- 发卡柜员编号
    ,card_iss_dt date -- 发卡日期
    ,pin_card_teller_id varchar2(60) -- 销卡柜员编号
    ,pin_card_dt date -- 销卡日期
    ,pin_card_rs_descb varchar2(100) -- 销卡原因描述
    ,change_card_cnt number(22) -- 换卡次数
    ,use_brch_range varchar2(60) -- 使用分行范围
    ,card_holder_name varchar2(750) -- 持卡人名称
    ,card_holder_cert_type_cd varchar2(10) -- 持卡人证件类型代码
    ,card_holder_cert_no varchar2(500) -- 持卡人证件号码
    ,final_tran_dt date -- 最后交易日期
    ,final_tran_flow varchar2(60) -- 最后交易流水
    ,final_offline_tran_dt date -- 最后脱机交易日期
    ,offline_tran_tot_amt number(30,2) -- 脱机交易总金额
    ,bal_uplmi number(30,2) -- 余额上限
    ,sig_cash_tran_lmt number(30,2) -- 单笔现金交易限额
    ,auto_load_tshold number(30,2) -- 自动圈存阀值
    ,auto_load_amt number(30,2) -- 自动圈存金额
    ,acm_load_amt number(30,2) -- 累计圈存金额
    ,acm_unload_amt number(30,2) -- 累计圈提金额
    ,curr_bal number(30,2) -- 当前余额
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_bank_card_basic_info to ${idl_schema};
grant select on ${icl_schema}.cmm_bank_card_basic_info to ${iel_schema};
grant select on ${icl_schema}.cmm_bank_card_basic_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_bank_card_basic_info is '银行卡基本信息';
comment on column ${icl_schema}.cmm_bank_card_basic_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_bank_card_basic_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_no is '卡号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_bin is '卡BIN';
comment on column ${icl_schema}.cmm_bank_card_basic_info.main_card_card_no is '主卡卡号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.vouch_no is '凭证号码';
comment on column ${icl_schema}.cmm_bank_card_basic_info.vouch_mgmt_id is '凭证管理编号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.nc_card_no is '无校验位卡号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.magt_ctrl_id is '写磁控制编号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_name is '卡名称';
comment on column ${icl_schema}.cmm_bank_card_basic_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.start_use_flg is '启用标志';
comment on column ${icl_schema}.cmm_bank_card_basic_info.vtual_card_flg is '虚拟卡标志';
comment on column ${icl_schema}.cmm_bank_card_basic_info.main_card_flg is '主卡标志';
comment on column ${icl_schema}.cmm_bank_card_basic_info.corp_stl_card_flg is '单位结算卡标志';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_psbook_merge_one_flg is '卡折合一标志';
comment on column ${icl_schema}.cmm_bank_card_basic_info.nomi_card_flg is '记名卡标志';
comment on column ${icl_schema}.cmm_bank_card_basic_info.vouch_kind_cd is '凭证种类代码';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_type_cd is '卡种类代码';
comment on column ${icl_schema}.cmm_bank_card_basic_info.co_card_type_cd is '合作卡类型代码';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_status_cd is '卡状态代码';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_level_cd is '卡等级代码';
comment on column ${icl_schema}.cmm_bank_card_basic_info.make_card_appl_id is '制卡申请编号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.make_card_flow_num is '制卡流水号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.make_card_dt is '制卡日期';
comment on column ${icl_schema}.cmm_bank_card_basic_info.effect_dt is '生效日期';
comment on column ${icl_schema}.cmm_bank_card_basic_info.invalid_dt is '失效日期';
comment on column ${icl_schema}.cmm_bank_card_basic_info.invalid_dt_pwd is '失效日期密文';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_iss_org_id is '发卡机构编号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_iss_teller_id is '发卡柜员编号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_iss_dt is '发卡日期';
comment on column ${icl_schema}.cmm_bank_card_basic_info.pin_card_teller_id is '销卡柜员编号';
comment on column ${icl_schema}.cmm_bank_card_basic_info.pin_card_dt is '销卡日期';
comment on column ${icl_schema}.cmm_bank_card_basic_info.pin_card_rs_descb is '销卡原因描述';
comment on column ${icl_schema}.cmm_bank_card_basic_info.change_card_cnt is '换卡次数';
comment on column ${icl_schema}.cmm_bank_card_basic_info.use_brch_range is '使用分行范围';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_holder_name is '持卡人名称';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_holder_cert_type_cd is '持卡人证件类型代码';
comment on column ${icl_schema}.cmm_bank_card_basic_info.card_holder_cert_no is '持卡人证件号码';
comment on column ${icl_schema}.cmm_bank_card_basic_info.final_tran_dt is '最后交易日期';
comment on column ${icl_schema}.cmm_bank_card_basic_info.final_tran_flow is '最后交易流水';
comment on column ${icl_schema}.cmm_bank_card_basic_info.final_offline_tran_dt is '最后脱机交易日期';
comment on column ${icl_schema}.cmm_bank_card_basic_info.offline_tran_tot_amt is '脱机交易总金额';
comment on column ${icl_schema}.cmm_bank_card_basic_info.bal_uplmi is '余额上限';
comment on column ${icl_schema}.cmm_bank_card_basic_info.sig_cash_tran_lmt is '单笔现金交易限额';
comment on column ${icl_schema}.cmm_bank_card_basic_info.auto_load_tshold is '自动圈存阀值';
comment on column ${icl_schema}.cmm_bank_card_basic_info.auto_load_amt is '自动圈存金额';
comment on column ${icl_schema}.cmm_bank_card_basic_info.acm_load_amt is '累计圈存金额';
comment on column ${icl_schema}.cmm_bank_card_basic_info.acm_unload_amt is '累计圈提金额';
comment on column ${icl_schema}.cmm_bank_card_basic_info.curr_bal is '当前余额';
comment on column ${icl_schema}.cmm_bank_card_basic_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_bank_card_basic_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_bank_card_basic_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_bank_card_basic_info.etl_timestamp is 'ETL处理时间戳';
