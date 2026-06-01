/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_hstctrans1_v_tbgrpprdtranscfm
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm(
    imp_date number(38) -- 导入日期
    ,prd_code varchar2(48) -- 产品代码
    ,bank_no varchar2(48) -- 银行代码:租户编号(多租户模式用)
    ,bank_acc varchar2(96) -- 资金账号
    ,trans_date number(38) -- 交易日期
    ,trans_time number(38) -- 交易时间
    ,ta_code varchar2(27) -- ta代码
    ,prd_type varchar2(2) -- 产品类型:1-基金
    ,ex_serial varchar2(48) -- 原始请求外部流水号
    ,grp_serial varchar2(192) -- 智能投顾流水号
    ,virtual_bank_acc varchar2(48) -- 虚拟银行账号
    ,serial_no varchar2(48) -- 流水序号:流水号
    ,trans_code varchar2(48) -- 交易代码
    ,cfm_amt number(18,2) -- 确认金额
    ,cfm_vol number(18,3) -- 确认份额
    ,err_code varchar2(18) -- 错误代码
    ,err_msg varchar2(768) -- 错误信息
    ,status varchar2(2) -- 状态
    ,cfm_date number(38) -- 确认日期
    ,cfm_fee number(18,2) -- 确认手续费
    ,cfm_nav number(18,8) -- 确认净值
    ,busin_code varchar2(9) -- 业务代码
    ,from_flag varchar2(2) -- 发起方:[k_fqf] 0	-  	系统 1	-  	ta 2	-  	其他
    ,cfm_no varchar2(48) -- ta确认流水号
    ,div_mode varchar2(2) -- 分红方式:0红利再投资,1现金红利
    ,div_date number(38) -- 分红日
    ,reg_date number(38) -- 登记日期
    ,in_client_no varchar2(30) -- 内部客户编号
    ,amt1 number(18,2) -- 备用金额1
    ,amt2 number(18,2) -- 备用金额2
    ,amt3 number(18,2) -- 备用金额3
    ,reserve1 varchar2(375) -- 保留字段1
    ,reserve2 varchar2(375) -- 保留字段2
    ,reserve3 varchar2(375) -- 保留字段3
    ,group_code varchar2(48) -- 分组代码
    ,group_name varchar2(384) -- 分组名称
    ,client_no varchar2(36) -- 银行客户号
    ,client_type varchar2(2) -- 客户类型:0机构,1个人,2产品
    ,amt number(18,2) -- 金额
    ,vol number(18,3) -- 份额
    ,modify_timestamp number(14,0) -- 修改时间戳
    ,back_amt number(18,2) -- 返款金额
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
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm to ${iml_schema};
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm to ${icl_schema};
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm to ${idl_schema};
grant select on ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm is '交易确认流水表';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.imp_date is '导入日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.prd_code is '产品代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.bank_no is '银行代码:租户编号(多租户模式用)';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.bank_acc is '资金账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.trans_date is '交易日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.trans_time is '交易时间';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.ta_code is 'ta代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.prd_type is '产品类型:1-基金';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.ex_serial is '原始请求外部流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.grp_serial is '智能投顾流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.virtual_bank_acc is '虚拟银行账号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.serial_no is '流水序号:流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.trans_code is '交易代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.cfm_amt is '确认金额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.cfm_vol is '确认份额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.err_code is '错误代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.err_msg is '错误信息';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.status is '状态';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.cfm_date is '确认日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.cfm_fee is '确认手续费';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.cfm_nav is '确认净值';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.busin_code is '业务代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.from_flag is '发起方:[k_fqf] 0	-  	系统 1	-  	ta 2	-  	其他';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.cfm_no is 'ta确认流水号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.div_mode is '分红方式:0红利再投资,1现金红利';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.div_date is '分红日';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.reg_date is '登记日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.in_client_no is '内部客户编号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.amt1 is '备用金额1';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.amt2 is '备用金额2';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.amt3 is '备用金额3';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.reserve1 is '保留字段1';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.reserve2 is '保留字段2';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.reserve3 is '保留字段3';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.group_code is '分组代码';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.group_name is '分组名称';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.client_no is '银行客户号';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.client_type is '客户类型:0机构,1个人,2产品';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.amt is '金额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.vol is '份额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.modify_timestamp is '修改时间戳';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.back_amt is '返款金额';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.nfss_hstctrans1_v_tbgrpprdtranscfm.etl_timestamp is 'ETL处理时间戳';
