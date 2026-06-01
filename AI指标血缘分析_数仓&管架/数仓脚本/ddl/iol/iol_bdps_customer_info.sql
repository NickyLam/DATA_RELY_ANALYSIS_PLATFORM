/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdps_customer_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdps_customer_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdps_customer_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_customer_info(
    id number(22,0) -- 
    ,cust_type number(22,0) -- 客户类别票据池：1-企业2-银行 3-非银行金融机构商票
    ,cust_no varchar2(30) -- 客户号
    ,cust_name varchar2(300) -- 客户名称
    ,cust_address varchar2(450) -- 地址
    ,telephone varchar2(75) -- 电知
    ,fax varchar2(75) -- 传真
    ,contacter varchar2(90) -- 联系人
    ,post varchar2(75) -- 邮政编码
    ,cust_email varchar2(75) -- 电子邮件
    ,province varchar2(9) -- 省份
    ,city varchar2(75) -- 城市
    ,class_id number(22,0) -- 性质id
    ,scale_id varchar2(3) -- 规模
    ,trade_type_id varchar2(9) -- 
    ,credit_level_id varchar2(3) -- 信用等级
    ,open_bank varchar2(75) -- 开户银行
    ,bank_account varchar2(90) -- 账号
    ,register_fund number(20,2) -- 注册资金
    ,cust_loan_card_no varchar2(45) -- 贷款卡号
    ,group_flag number(22,0) -- 是否集团客户票据池：0-否 1-是
    ,group_id number(22,0) -- 上级公司
    ,bank_no varchar2(23) -- 银行行号
    ,bank_cate_id number(22,0) -- 行分类id
    ,bank_level number(22,0) -- 行级别票据池：1-总行2-一级分行3-二级分行
    ,union_id number(22,0) -- 联行号(银行客户用)
    ,bln_brh_id varchar2(75) -- 所属机构表
    ,valid_flag number(22,0) -- 生效标志票据池：0-?未生效 1-生效
    ,credit_flag number(22,0) -- 是否授信客户票据池：0-否1-是
    ,organ_code varchar2(75) -- 组织机构代码
    ,in_flag number(22,0) -- 是否系统内客户-产品表（票据池系统无值）0-?否 1-是
    ,last_upd_oper_id number(22,0) -- 最后更新操作员
    ,last_upd_time varchar2(21) -- 最后更新时间
    ,chief_bank_flag number(22,0) -- 是否总行票据池：0-否1-是
    ,dualcontrol_lockstatus varchar2(2) -- 
    ,cust_yyzh varchar2(48) -- 营业执照号*（核心）db.customer.cust_yyzh
    ,cust_sign_add varchar2(120) -- 注册地址
    ,cust_farener varchar2(300) -- 法人代表名称
    ,cust_faren_card_no varchar2(30) -- 法人代表证件号
    ,cust_is_gd number(22,0) -- 是否我行股东
    ,cust_jr_allow_no varchar2(90) -- 金融许可证号
    ,cust_eff_dt date -- 营业执照有效日期
    ,cust_install_dt date -- 企业成立日期
    ,card_if_enable number(22,0) -- 贷款卡号是否有效-产品表（票据池系统无值）
    ,souceflag varchar2(6) -- 来源cbms-商票 lbms-票据池(本系统维护) sasb-核心 cmsf-老信贷
    ,auto_account varchar2(2) -- 托收回款是否自动入账0-否1-是
    ,parent_company_name varchar2(383) -- 母公司客户名
    ,cus_manager_code varchar2(60) -- 分管客户经理号
    ,cus_manager_name varchar2(60) -- 分管客户经理名
    ,company_cust_no varchar2(90) -- 集团客户号
    ,parent_company_no varchar2(45) -- 母公司客户号
    ,usci_code varchar2(30) -- 统一社会信用代码
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
grant select on ${iol_schema}.bdps_customer_info to ${iml_schema};
grant select on ${iol_schema}.bdps_customer_info to ${icl_schema};
grant select on ${iol_schema}.bdps_customer_info to ${idl_schema};
grant select on ${iol_schema}.bdps_customer_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdps_customer_info is '客户信息表';
comment on column ${iol_schema}.bdps_customer_info.id is '';
comment on column ${iol_schema}.bdps_customer_info.cust_type is '客户类别票据池：1-企业2-银行 3-非银行金融机构商票';
comment on column ${iol_schema}.bdps_customer_info.cust_no is '客户号';
comment on column ${iol_schema}.bdps_customer_info.cust_name is '客户名称';
comment on column ${iol_schema}.bdps_customer_info.cust_address is '地址';
comment on column ${iol_schema}.bdps_customer_info.telephone is '电知';
comment on column ${iol_schema}.bdps_customer_info.fax is '传真';
comment on column ${iol_schema}.bdps_customer_info.contacter is '联系人';
comment on column ${iol_schema}.bdps_customer_info.post is '邮政编码';
comment on column ${iol_schema}.bdps_customer_info.cust_email is '电子邮件';
comment on column ${iol_schema}.bdps_customer_info.province is '省份';
comment on column ${iol_schema}.bdps_customer_info.city is '城市';
comment on column ${iol_schema}.bdps_customer_info.class_id is '性质id';
comment on column ${iol_schema}.bdps_customer_info.scale_id is '规模';
comment on column ${iol_schema}.bdps_customer_info.trade_type_id is '';
comment on column ${iol_schema}.bdps_customer_info.credit_level_id is '信用等级';
comment on column ${iol_schema}.bdps_customer_info.open_bank is '开户银行';
comment on column ${iol_schema}.bdps_customer_info.bank_account is '账号';
comment on column ${iol_schema}.bdps_customer_info.register_fund is '注册资金';
comment on column ${iol_schema}.bdps_customer_info.cust_loan_card_no is '贷款卡号';
comment on column ${iol_schema}.bdps_customer_info.group_flag is '是否集团客户票据池：0-否 1-是';
comment on column ${iol_schema}.bdps_customer_info.group_id is '上级公司';
comment on column ${iol_schema}.bdps_customer_info.bank_no is '银行行号';
comment on column ${iol_schema}.bdps_customer_info.bank_cate_id is '行分类id';
comment on column ${iol_schema}.bdps_customer_info.bank_level is '行级别票据池：1-总行2-一级分行3-二级分行';
comment on column ${iol_schema}.bdps_customer_info.union_id is '联行号(银行客户用)';
comment on column ${iol_schema}.bdps_customer_info.bln_brh_id is '所属机构表';
comment on column ${iol_schema}.bdps_customer_info.valid_flag is '生效标志票据池：0-?未生效 1-生效';
comment on column ${iol_schema}.bdps_customer_info.credit_flag is '是否授信客户票据池：0-否1-是';
comment on column ${iol_schema}.bdps_customer_info.organ_code is '组织机构代码';
comment on column ${iol_schema}.bdps_customer_info.in_flag is '是否系统内客户-产品表（票据池系统无值）0-?否 1-是';
comment on column ${iol_schema}.bdps_customer_info.last_upd_oper_id is '最后更新操作员';
comment on column ${iol_schema}.bdps_customer_info.last_upd_time is '最后更新时间';
comment on column ${iol_schema}.bdps_customer_info.chief_bank_flag is '是否总行票据池：0-否1-是';
comment on column ${iol_schema}.bdps_customer_info.dualcontrol_lockstatus is '';
comment on column ${iol_schema}.bdps_customer_info.cust_yyzh is '营业执照号*（核心）db.customer.cust_yyzh';
comment on column ${iol_schema}.bdps_customer_info.cust_sign_add is '注册地址';
comment on column ${iol_schema}.bdps_customer_info.cust_farener is '法人代表名称';
comment on column ${iol_schema}.bdps_customer_info.cust_faren_card_no is '法人代表证件号';
comment on column ${iol_schema}.bdps_customer_info.cust_is_gd is '是否我行股东';
comment on column ${iol_schema}.bdps_customer_info.cust_jr_allow_no is '金融许可证号';
comment on column ${iol_schema}.bdps_customer_info.cust_eff_dt is '营业执照有效日期';
comment on column ${iol_schema}.bdps_customer_info.cust_install_dt is '企业成立日期';
comment on column ${iol_schema}.bdps_customer_info.card_if_enable is '贷款卡号是否有效-产品表（票据池系统无值）';
comment on column ${iol_schema}.bdps_customer_info.souceflag is '来源cbms-商票 lbms-票据池(本系统维护) sasb-核心 cmsf-老信贷';
comment on column ${iol_schema}.bdps_customer_info.auto_account is '托收回款是否自动入账0-否1-是';
comment on column ${iol_schema}.bdps_customer_info.parent_company_name is '母公司客户名';
comment on column ${iol_schema}.bdps_customer_info.cus_manager_code is '分管客户经理号';
comment on column ${iol_schema}.bdps_customer_info.cus_manager_name is '分管客户经理名';
comment on column ${iol_schema}.bdps_customer_info.company_cust_no is '集团客户号';
comment on column ${iol_schema}.bdps_customer_info.parent_company_no is '母公司客户号';
comment on column ${iol_schema}.bdps_customer_info.usci_code is '统一社会信用代码';
comment on column ${iol_schema}.bdps_customer_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdps_customer_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdps_customer_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdps_customer_info.etl_timestamp is 'ETL处理时间戳';
