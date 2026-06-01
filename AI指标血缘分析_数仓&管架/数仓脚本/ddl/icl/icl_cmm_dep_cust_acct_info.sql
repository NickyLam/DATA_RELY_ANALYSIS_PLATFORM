/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_dep_cust_acct_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_dep_cust_acct_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_dep_cust_acct_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_dep_cust_acct_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,acct_id varchar2(100) -- 账户编号
    ,cust_acct_id varchar2(60) -- 客户账户编号
    ,cust_acct_card_no varchar2(60) -- 客户账户卡号
    ,cust_acct_name varchar2(300) -- 客户账户名称
    ,cust_id varchar2(60) -- 客户编号
    ,max_sub_acct_num varchar2(60) -- 最大子户号
    ,std_prod_id varchar2(60) -- 标准产品编号
    ,drawdown_way_cd varchar2(10) -- 支取方式代码
    ,acct_status_cd varchar2(10) -- 账户状态代码
    ,acct_type_cd varchar2(10) -- 账户等级代码
    ,acct_attr_cd varchar2(10) -- 账户属性代码
    ,e_acct_type_cd varchar2(10) -- 电子账户类型代码
    ,e_acct_status_cd varchar2(10) -- 电子账户状态代码
    ,acct_drawdown_way_status varchar2(10) -- 账户支取方式状态
    ,froz_status_cd varchar2(10) -- 冻结状态代码
    ,stop_pay_status_cd varchar2(10) -- 止付状态代码
    ,acpt_pay_status_cd varchar2(10) -- 收付状态代码
    ,acct_usage_cd varchar2(30) -- 账户用途代码
    ,vouch_kind_cd varchar2(10) -- 凭证种类代码
    ,vouch_char_cd varchar2(10) -- 凭证性质代码
    ,vouch_form_cd varchar2(10) -- 凭证形式代码
    ,netw_vrfction_rest_cd varchar2(30) -- 联网核查结果代码
    ,vrif_status_cd varchar2(30) -- 核实状态代码
    ,curr_cd varchar2(10) -- 币种代码
    ,reg_acct_type_cd varchar2(10) -- 定期账户类型代码
    ,src_module_type_cd varchar2(10) -- 源模块类型代码
    ,sleep_acct_flg varchar2(10) -- 睡眠户标志
    ,dormt_acct_flg varchar2(10) -- 不动户标志
    ,privavy_acct_flg varchar2(10) -- 隐私账户标志
    ,corp_acct_flg varchar2(10) -- 对公账户标志
    ,bind_acct_flg varchar2(10) -- 绑定账户标志
    ,fiscal_dep_flg varchar2(10) -- 财政性存款标志
    ,general_exch_flg varchar2(10) -- 通兑标志
    ,general_exch_org_id varchar2(60) -- 通兑机构编号
    ,travel_card_acct_flg varchar2(10) -- 旅行通账户标志
    ,travel_card_valid_dt date -- 旅行通卡有效期
    ,acct_belong_org_id varchar2(60) -- 账户所属机构编号
    ,open_acct_org_id varchar2(60) -- 开户机构编号
    ,open_acct_teller_id varchar2(60) -- 开户柜员编号
    ,open_acct_chn_cd varchar2(10) -- 开户渠道编号
    ,open_acct_flow_num varchar2(60) -- 开户流水号
    ,open_acct_dt date -- 开户日期
    ,open_acct_tm timestamp(6) -- 开户时间
    ,close_acct_org_id varchar2(60) -- 销户机构编号
    ,clos_acct_teller_id varchar2(60) -- 销户柜员编号
    ,clos_acct_flow_num varchar2(60) -- 销户流水号
    ,clos_acct_dt date -- 销户日期
    ,clos_acct_tm timestamp(6) -- 销户时间
    ,unvrif_rs_descb varchar2(300) -- 无法核实原因描述
    ,disp_method_descb varchar2(100) -- 处置方法描述
    ,tran_chn_status_cd varchar2(60) -- 交易渠道状态代码
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
grant select on ${icl_schema}.cmm_dep_cust_acct_info to ${idl_schema};
grant select on ${icl_schema}.cmm_dep_cust_acct_info to ${iel_schema};
grant select on ${icl_schema}.cmm_dep_cust_acct_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_dep_cust_acct_info is '存款主账户信息';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.cust_acct_id is '客户账户编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.cust_acct_card_no is '客户账户卡号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.cust_acct_name is '客户账户名称';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.max_sub_acct_num is '最大子户号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.std_prod_id is '标准产品编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.drawdown_way_cd is '支取方式代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.acct_status_cd is '账户状态代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.acct_type_cd is '账户等级代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.acct_attr_cd is '账户属性代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.e_acct_type_cd is '电子账户类型代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.e_acct_status_cd is '电子账户状态代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.acct_drawdown_way_status is '账户支取方式状态';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.froz_status_cd is '冻结状态代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.stop_pay_status_cd is '止付状态代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.acpt_pay_status_cd is '收付状态代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.acct_usage_cd is '账户用途代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.vouch_kind_cd is '凭证种类代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.vouch_char_cd is '凭证性质代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.vouch_form_cd is '凭证形式代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.netw_vrfction_rest_cd is '联网核查结果代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.vrif_status_cd is '核实状态代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.curr_cd is '币种代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.reg_acct_type_cd is '定期账户类型代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.src_module_type_cd is '源模块类型代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.sleep_acct_flg is '睡眠户标志';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.dormt_acct_flg is '不动户标志';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.privavy_acct_flg is '隐私账户标志';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.corp_acct_flg is '对公账户标志';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.bind_acct_flg is '绑定账户标志';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.fiscal_dep_flg is '财政性存款标志';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.general_exch_flg is '通兑标志';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.general_exch_org_id is '通兑机构编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.travel_card_acct_flg is '旅行通账户标志';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.travel_card_valid_dt is '旅行通卡有效期';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.acct_belong_org_id is '账户所属机构编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.open_acct_org_id is '开户机构编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.open_acct_teller_id is '开户柜员编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.open_acct_chn_cd is '开户渠道编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.open_acct_flow_num is '开户流水号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.open_acct_dt is '开户日期';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.open_acct_tm is '开户时间';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.close_acct_org_id is '销户机构编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.clos_acct_teller_id is '销户柜员编号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.clos_acct_flow_num is '销户流水号';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.clos_acct_dt is '销户日期';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.clos_acct_tm is '销户时间';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.unvrif_rs_descb is '无法核实原因描述';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.disp_method_descb is '处置方法描述';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.tran_chn_status_cd is '交易渠道状态代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_dep_cust_acct_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_dep_cust_acct_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_dep_cust_acct_info.etl_timestamp is 'ETL处理时间戳';
