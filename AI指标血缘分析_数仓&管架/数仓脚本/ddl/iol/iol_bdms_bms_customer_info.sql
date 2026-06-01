/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_customer_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_customer_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_customer_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_customer_info(
    id varchar2(60) -- ID
    ,cust_type varchar2(2) -- 客户类型
    ,cust_no varchar2(24) -- 客户编号
    ,role_type varchar2(6) -- 参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司
    ,cust_name varchar2(300) -- 客户名称
    ,cust_address varchar2(600) -- 地址
    ,telephone varchar2(45) -- 电话号码
    ,fax varchar2(60) -- 传真
    ,contacter varchar2(90) -- 联系人
    ,post varchar2(45) -- 邮政编码
    ,province varchar2(9) -- 行政区划
    ,city varchar2(45) -- 城市
    ,class_id varchar2(54) -- 性质ID
    ,scale_id varchar2(54) -- 企业规模
    ,trade_type_id varchar2(9) -- 所属行业类型
    ,credit_level_id varchar2(54) -- 信用等级ID
    ,register_fund varchar2(75) -- 注册资金
    ,group_flag varchar2(2) -- 集团客户标志
    ,group_id varchar2(60) -- 集团客户ID
    ,bank_no varchar2(18) -- 人行支付行号
    ,bank_cate_id varchar2(54) -- 行分类ID
    ,bank_level varchar2(2) -- 行级别
    ,bln_brh_no varchar2(18) -- 管理机构编号
    ,top_branch_no varchar2(30) -- 所属总行机构
    ,company_up varchar2(60) -- 上级公司
    ,company_flag varchar2(2) -- 是否总公司： 0 否 1 是
    ,valid_flag varchar2(2) -- 生效标志
    ,credit_flag varchar2(2) -- 是否授信客户： 0 否 1 是
    ,organ_code varchar2(60) -- 组织机构代码
    ,has_sign_web varchar2(2) -- 签约网银标志
    ,last_upd_oper_no varchar2(45) -- 最后更新操作员
    ,last_upd_time date -- 最后更新时间
    ,group_rake varchar2(2) -- 是否占用集团客户额度： 0 否 1 是
    ,dualcontrol_locks varchar2(2) -- 双岗复核锁标记
    ,agent_flag varchar2(2) -- 
    ,top_bank_no varchar2(18) -- 
    ,account_no varchar2(45) -- 
    ,delete_flag varchar2(2) -- 删除标志： 0 否 1 是
    ,ind_cls varchar2(8) -- 票交所行业分类
    ,corp_scale varchar2(6) -- 票交所企业规模
    ,arc_flag varchar2(2) -- 是否三农企业：0-否 1-是
    ,grn_flag varchar2(2) -- 是否绿色企业：0-否 1-是
    ,social_credit_no varchar2(27) -- 统一社会信用代码
    ,sci_flag varchar2(2) -- 是否科技企业： 0 否 1 是
    ,pop_flag varchar2(2) -- 是否民企： 0 否 1 是
    ,brh_no varchar2(14) -- 会员机构代码
    ,create_time varchar2(12) -- 创建时间
    ,quick_accept_flag varchar2(2) -- 是否签约秒开： 0 否 1 是
    ,quick_discount_flag varchar2(2) -- 是否签约秒贴： 0 否 1 是
    ,quick_collztn_flag varchar2(2) -- 是否签约秒押： 0 否 1 是
    ,cross_flag varchar2(2) -- 
    ,showr_acct_no varchar2(30) -- 
    ,cpes_cust_info_id varchar2(60) -- 
    ,message_status varchar2(3) -- 
    ,reg_addr varchar2(450) -- 
    ,per_name varchar2(60) -- 
    ,doc_tp varchar2(4) -- 
    ,doc_no varchar2(90) -- 法定代表人证件号码
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
grant select on ${iol_schema}.bdms_bms_customer_info to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_customer_info to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_customer_info to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_customer_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_customer_info is '客户信息表';
comment on column ${iol_schema}.bdms_bms_customer_info.id is 'ID';
comment on column ${iol_schema}.bdms_bms_customer_info.cust_type is '客户类型';
comment on column ${iol_schema}.bdms_bms_customer_info.cust_no is '客户编号';
comment on column ${iol_schema}.bdms_bms_customer_info.role_type is '参与者类别： RC00 接入行 RC01 企业 RC02 人民银行 RC03 被代理行 RC04 被代理财务公司 RC05 接入财务公司';
comment on column ${iol_schema}.bdms_bms_customer_info.cust_name is '客户名称';
comment on column ${iol_schema}.bdms_bms_customer_info.cust_address is '地址';
comment on column ${iol_schema}.bdms_bms_customer_info.telephone is '电话号码';
comment on column ${iol_schema}.bdms_bms_customer_info.fax is '传真';
comment on column ${iol_schema}.bdms_bms_customer_info.contacter is '联系人';
comment on column ${iol_schema}.bdms_bms_customer_info.post is '邮政编码';
comment on column ${iol_schema}.bdms_bms_customer_info.province is '行政区划';
comment on column ${iol_schema}.bdms_bms_customer_info.city is '城市';
comment on column ${iol_schema}.bdms_bms_customer_info.class_id is '性质ID';
comment on column ${iol_schema}.bdms_bms_customer_info.scale_id is '企业规模';
comment on column ${iol_schema}.bdms_bms_customer_info.trade_type_id is '所属行业类型';
comment on column ${iol_schema}.bdms_bms_customer_info.credit_level_id is '信用等级ID';
comment on column ${iol_schema}.bdms_bms_customer_info.register_fund is '注册资金';
comment on column ${iol_schema}.bdms_bms_customer_info.group_flag is '集团客户标志';
comment on column ${iol_schema}.bdms_bms_customer_info.group_id is '集团客户ID';
comment on column ${iol_schema}.bdms_bms_customer_info.bank_no is '人行支付行号';
comment on column ${iol_schema}.bdms_bms_customer_info.bank_cate_id is '行分类ID';
comment on column ${iol_schema}.bdms_bms_customer_info.bank_level is '行级别';
comment on column ${iol_schema}.bdms_bms_customer_info.bln_brh_no is '管理机构编号';
comment on column ${iol_schema}.bdms_bms_customer_info.top_branch_no is '所属总行机构';
comment on column ${iol_schema}.bdms_bms_customer_info.company_up is '上级公司';
comment on column ${iol_schema}.bdms_bms_customer_info.company_flag is '是否总公司： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_customer_info.valid_flag is '生效标志';
comment on column ${iol_schema}.bdms_bms_customer_info.credit_flag is '是否授信客户： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_customer_info.organ_code is '组织机构代码';
comment on column ${iol_schema}.bdms_bms_customer_info.has_sign_web is '签约网银标志';
comment on column ${iol_schema}.bdms_bms_customer_info.last_upd_oper_no is '最后更新操作员';
comment on column ${iol_schema}.bdms_bms_customer_info.last_upd_time is '最后更新时间';
comment on column ${iol_schema}.bdms_bms_customer_info.group_rake is '是否占用集团客户额度： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_customer_info.dualcontrol_locks is '双岗复核锁标记';
comment on column ${iol_schema}.bdms_bms_customer_info.agent_flag is '';
comment on column ${iol_schema}.bdms_bms_customer_info.top_bank_no is '';
comment on column ${iol_schema}.bdms_bms_customer_info.account_no is '';
comment on column ${iol_schema}.bdms_bms_customer_info.delete_flag is '删除标志： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_customer_info.ind_cls is '票交所行业分类';
comment on column ${iol_schema}.bdms_bms_customer_info.corp_scale is '票交所企业规模';
comment on column ${iol_schema}.bdms_bms_customer_info.arc_flag is '是否三农企业：0-否 1-是';
comment on column ${iol_schema}.bdms_bms_customer_info.grn_flag is '是否绿色企业：0-否 1-是';
comment on column ${iol_schema}.bdms_bms_customer_info.social_credit_no is '统一社会信用代码';
comment on column ${iol_schema}.bdms_bms_customer_info.sci_flag is '是否科技企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_customer_info.pop_flag is '是否民企： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_customer_info.brh_no is '会员机构代码';
comment on column ${iol_schema}.bdms_bms_customer_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_bms_customer_info.quick_accept_flag is '是否签约秒开： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_customer_info.quick_discount_flag is '是否签约秒贴： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_customer_info.quick_collztn_flag is '是否签约秒押： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_customer_info.cross_flag is '';
comment on column ${iol_schema}.bdms_bms_customer_info.showr_acct_no is '';
comment on column ${iol_schema}.bdms_bms_customer_info.cpes_cust_info_id is '';
comment on column ${iol_schema}.bdms_bms_customer_info.message_status is '';
comment on column ${iol_schema}.bdms_bms_customer_info.reg_addr is '';
comment on column ${iol_schema}.bdms_bms_customer_info.per_name is '';
comment on column ${iol_schema}.bdms_bms_customer_info.doc_tp is '';
comment on column ${iol_schema}.bdms_bms_customer_info.doc_no is '法定代表人证件号码';
comment on column ${iol_schema}.bdms_bms_customer_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_customer_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_customer_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_customer_info.etl_timestamp is 'ETL处理时间戳';
