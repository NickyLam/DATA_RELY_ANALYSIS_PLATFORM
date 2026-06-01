/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_rep_prod_declare
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_rep_prod_declare
whenever sqlerror continue none;
drop table ${iol_schema}.fams_rep_prod_declare purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_rep_prod_declare(
    rep_finprod_id varchar2(50) -- 金融产品代码
    ,rep_finprod_name varchar2(300) -- 金融产品名称
    ,rep_finprod_reg_id varchar2(15) -- 产品登记编码
    ,rep_finprod_ins_id varchar2(100) -- 行内标识码
    ,rep_finprod_brand varchar2(180) -- 产品品牌
    ,rep_finprod_stage number(6) -- 产品期次
    ,rep_issue_party_id varchar2(6) -- 发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）
    ,rep_approver_id varchar2(30) -- 产品审批人身份证号
    ,rep_approver_name varchar2(300) -- 产品审批人姓名
    ,rep_designer_id varchar2(30) -- 产品设计人身份证号
    ,rep_designer_name varchar2(300) -- 产品设计人姓名
    ,rep_manager_id varchar2(30) -- 投资经理身份证号
    ,rep_manager_name varchar2(300) -- 投资经理姓名
    ,rep_liaison_name varchar2(48) -- 业务联络人姓名
    ,rep_liaison_tel varchar2(30) -- 业务联络人座机
    ,rep_liaison_mobile varchar2(11) -- 业务联络人手机
    ,rep_liaison_email varchar2(50) -- 业务联络人邮箱
    ,rep_profit_type varchar2(50) -- 产品收益类型
    ,rep_term varchar2(50) -- 产品期限
    ,rep_investor_type varchar2(50) -- 投资者类型
    ,rep_invest_area varchar2(50) -- 资金投向地区
    ,rep_invest_country varchar2(1000) -- 产品投资国家或地区
    ,rep_finan_ser_model varchar2(50) -- 理财业务服务模式
    ,rep_operate_mode varchar2(50) -- 产品运作模式
    ,rep_book_mode varchar2(50) -- 会计核算方式
    ,rep_cmmode varchar2(50) -- 产品资产配置方式
    ,rep_pmmode varchar2(50) -- 产品管理模式
    ,rep_mname varchar2(180) -- 实际管理人员名称
    ,rep_priced_mode varchar2(50) -- 产品定价方式
    ,rep_inv_asset_type varchar2(50) -- 投资资产类型
    ,rep_con_prd_traget varchar2(50) -- 结构性产品挂钩标的
    ,rep_cont_mode varchar2(50) -- 合作模式
    ,rep_coop_name varchar2(180) -- 合作机构名称
    ,rep_inv_type_rat varchar2(450) -- 投资资产种类及比例
    ,rep_is_yield varchar2(50) -- 是否有预期收益率
    ,rep_high_yield number(8,5) -- 预计客户最高年收益率
    ,rep_low_yield number(8,5) -- 预计客户最低年收益率
    ,rep_is_yield_basis varchar2(50) -- 是否有收益率测算依据
    ,rep_risk_type varchar2(50) -- 投资者风险偏好
    ,rep_sale_area varchar2(1000) -- 产品销售区域
    ,rep_raise_ccy varchar2(50) -- 募集币种
    ,rep_cash_prin_ccy varchar2(1000) -- 兑付本金币种
    ,rep_cash_prof_ccy varchar2(1000) -- 兑付收益币种
    ,rep_sale_amt_str number(15,2) -- 起点销售金额
    ,rep_raise_amt_plan number(15,2) -- 计划募集金额
    ,rep_raise_pstrdate date -- 募集起始日期（从）
    ,rep_raise_penddate date -- 募集起始日期（到）
    ,rep_invest_prin_date varchar2(50) -- 投资本金到账日
    ,rep_invest_prof_date varchar2(50) -- 投资收益到账日
    ,rep_sale_fee_rate number(8,5) -- 销售手续费
    ,rep_in_dep_name varchar2(180) -- 境内托管机构名称
    ,rep_in_dep_code varchar2(12) -- 境内托管机构代码
    ,rep_out_dep_ctry varchar2(1000) -- 境外托管机构国别
    ,rep_out_dep_name varchar2(300) -- 境外托管机构名称
    ,rep_tru_fee_rate number(8,5) -- 托管费率
    ,rep_risk_level varchar2(3) -- 产品风险等级
    ,rep_term_right_flag varchar2(2) -- 发型机构提前终止权标识
    ,rep_cus_redeem_flag varchar2(2) -- 客户赎回权标识
    ,rep_credit_flag varchar2(2) -- 产品增信标识
    ,rep_credit_type varchar2(200) -- 产品增信机构类型
    ,rep_credit_mode varchar2(2) -- 产品增信形式
    ,rep_remark varchar2(384) -- 备注
    ,rep_declare_date date -- 报告登记日
    ,rep_send_status varchar2(50) -- 报送状态
    ,rep_status_date date -- 数据日期
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,exc_fin_sector varchar2(2) -- 是否金融同业专属
    ,is_short_term varchar2(2) -- 是否设置最短持有期限
    ,short_term number(30,8) -- 最短持有期限(天)
    ,is_free_redem varchar2(2) -- 最短持有期后是否自由赎回
    ,customer_type varchar2(20) -- 客户类型-人行报送
    ,rep_issue_type varchar2(2) -- 产品募集方式
    ,rep_yield varchar2(30) -- 业绩比较基准%
    ,rep_invest_nature varchar2(50) -- 产品投资性质
    ,rep_is_cash_manage varchar2(2) -- 是否现金管理类
    ,rep_invest_fee_rate varchar2(30) -- 投资管理费率%
    ,rep_fiduciary_duty varchar2(2) -- 是否收益权转让产品
    ,rep_fprod_id varchar2(50) -- 母产品代码
    ,buy_place varchar2(50) -- 销售区域
    ,customer_type1 varchar2(50) -- 客户一级类型
    ,customer_type2 varchar2(50) -- 客户二级类型
    ,prd_spec_property varchar2(32) -- 产品特殊属性
    ,base_info_sign varchar2(1) -- 基本信息公开标识
    ,change_reason varchar2(200) -- 变更原因
    ,rep_extension_flag varchar2(1) -- 产品展期标识
    ,rep_is_in_liquidation varchar2(1) -- 是否处于清算中
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_rep_prod_declare to ${iml_schema};
grant select on ${iol_schema}.fams_rep_prod_declare to ${icl_schema};
grant select on ${iol_schema}.fams_rep_prod_declare to ${idl_schema};
grant select on ${iol_schema}.fams_rep_prod_declare to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_rep_prod_declare is '产品申报报送信息';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_finprod_name is '金融产品名称';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_finprod_reg_id is '产品登记编码';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_finprod_ins_id is '行内标识码';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_finprod_brand is '产品品牌';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_finprod_stage is '产品期次';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_issue_party_id is '发行机构代码（中债那边每家银行固定一个代码，联社是以分设为单位的）';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_approver_id is '产品审批人身份证号';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_approver_name is '产品审批人姓名';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_designer_id is '产品设计人身份证号';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_designer_name is '产品设计人姓名';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_manager_id is '投资经理身份证号';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_manager_name is '投资经理姓名';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_liaison_name is '业务联络人姓名';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_liaison_tel is '业务联络人座机';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_liaison_mobile is '业务联络人手机';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_liaison_email is '业务联络人邮箱';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_profit_type is '产品收益类型';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_term is '产品期限';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_investor_type is '投资者类型';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_invest_area is '资金投向地区';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_invest_country is '产品投资国家或地区';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_finan_ser_model is '理财业务服务模式';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_operate_mode is '产品运作模式';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_book_mode is '会计核算方式';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_cmmode is '产品资产配置方式';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_pmmode is '产品管理模式';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_mname is '实际管理人员名称';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_priced_mode is '产品定价方式';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_inv_asset_type is '投资资产类型';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_con_prd_traget is '结构性产品挂钩标的';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_cont_mode is '合作模式';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_coop_name is '合作机构名称';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_inv_type_rat is '投资资产种类及比例';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_is_yield is '是否有预期收益率';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_high_yield is '预计客户最高年收益率';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_low_yield is '预计客户最低年收益率';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_is_yield_basis is '是否有收益率测算依据';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_risk_type is '投资者风险偏好';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_sale_area is '产品销售区域';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_raise_ccy is '募集币种';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_cash_prin_ccy is '兑付本金币种';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_cash_prof_ccy is '兑付收益币种';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_sale_amt_str is '起点销售金额';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_raise_amt_plan is '计划募集金额';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_raise_pstrdate is '募集起始日期（从）';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_raise_penddate is '募集起始日期（到）';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_invest_prin_date is '投资本金到账日';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_invest_prof_date is '投资收益到账日';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_sale_fee_rate is '销售手续费';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_in_dep_name is '境内托管机构名称';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_in_dep_code is '境内托管机构代码';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_out_dep_ctry is '境外托管机构国别';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_out_dep_name is '境外托管机构名称';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_tru_fee_rate is '托管费率';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_risk_level is '产品风险等级';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_term_right_flag is '发型机构提前终止权标识';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_cus_redeem_flag is '客户赎回权标识';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_credit_flag is '产品增信标识';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_credit_type is '产品增信机构类型';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_credit_mode is '产品增信形式';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_remark is '备注';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_declare_date is '报告登记日';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_send_status is '报送状态';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_status_date is '数据日期';
comment on column ${iol_schema}.fams_rep_prod_declare.create_user is '创建人';
comment on column ${iol_schema}.fams_rep_prod_declare.create_dept is '创建部门';
comment on column ${iol_schema}.fams_rep_prod_declare.create_time is '创建时间';
comment on column ${iol_schema}.fams_rep_prod_declare.update_user is '更新人';
comment on column ${iol_schema}.fams_rep_prod_declare.update_time is '更新时间';
comment on column ${iol_schema}.fams_rep_prod_declare.exc_fin_sector is '是否金融同业专属';
comment on column ${iol_schema}.fams_rep_prod_declare.is_short_term is '是否设置最短持有期限';
comment on column ${iol_schema}.fams_rep_prod_declare.short_term is '最短持有期限(天)';
comment on column ${iol_schema}.fams_rep_prod_declare.is_free_redem is '最短持有期后是否自由赎回';
comment on column ${iol_schema}.fams_rep_prod_declare.customer_type is '客户类型-人行报送';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_issue_type is '产品募集方式';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_yield is '业绩比较基准%';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_invest_nature is '产品投资性质';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_is_cash_manage is '是否现金管理类';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_invest_fee_rate is '投资管理费率%';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_fiduciary_duty is '是否收益权转让产品';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_fprod_id is '母产品代码';
comment on column ${iol_schema}.fams_rep_prod_declare.buy_place is '销售区域';
comment on column ${iol_schema}.fams_rep_prod_declare.customer_type1 is '客户一级类型';
comment on column ${iol_schema}.fams_rep_prod_declare.customer_type2 is '客户二级类型';
comment on column ${iol_schema}.fams_rep_prod_declare.prd_spec_property is '产品特殊属性';
comment on column ${iol_schema}.fams_rep_prod_declare.base_info_sign is '基本信息公开标识';
comment on column ${iol_schema}.fams_rep_prod_declare.change_reason is '变更原因';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_extension_flag is '产品展期标识';
comment on column ${iol_schema}.fams_rep_prod_declare.rep_is_in_liquidation is '是否处于清算中';
comment on column ${iol_schema}.fams_rep_prod_declare.start_dt is '开始时间';
comment on column ${iol_schema}.fams_rep_prod_declare.end_dt is '结束时间';
comment on column ${iol_schema}.fams_rep_prod_declare.id_mark is '增删标志';
comment on column ${iol_schema}.fams_rep_prod_declare.etl_timestamp is 'ETL处理时间戳';
