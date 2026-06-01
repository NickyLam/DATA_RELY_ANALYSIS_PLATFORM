/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpp_cust_register_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpp_cust_register_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpp_cust_register_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpp_cust_register_info(
    id varchar2(60) -- ID
    ,busi_id varchar2(60) -- 业务表ID
    ,busi_type varchar2(5) -- 业务类型： 300 登记 301 解除登记
    ,opr_type varchar2(6) -- 操作类型： AT01 新增 AT02 修改 AT99 查询
    ,reg_brh_no varchar2(15) -- 登记机构代码
    ,cpp_cust_name varchar2(300) -- 申请人名称
    ,cpp_social_no varchar2(27) -- 申请人社会信用代码
    ,cpp_corp_scale varchar2(6) -- 规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
    ,cpp_ind_cls varchar2(8) -- 行业分类：详见概述分册
    ,cpp_arc_flag varchar2(2) -- 是否涉农企业： 0 否 1 是
    ,cpp_grn_flag varchar2(2) -- 是否绿色企业： 0 否 1 是
    ,cpp_sci_flag varchar2(2) -- 是否科技企业： 0 否 1 是
    ,cpp_pop_flag varchar2(2) -- 是否民营企业： 0 否 1 是
    ,cpp_province varchar2(3) -- 贴现申请人省份：参见附录省份代码
    ,reg_status varchar2(8) -- 登记状态： DRS01 正常 DRS02 失效
    ,process_code varchar2(30) -- 处理码
    ,process_msg varchar2(300) -- 处理信息
    ,last_upd_opr varchar2(45) -- 最后操作员
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,misc varchar2(1500) -- 备注
    ,cpp_signature varchar2(270) -- 中证码
    ,cpp_address varchar2(675) -- 住所/地址
    ,cpp_ctgy varchar2(6) -- 类型
    ,cpp_corp_type varchar2(6) -- 企业所有制形式
    ,cpp_reg_cap number(18,2) -- 注册资本(万元)
    ,cpp_busi_in number(18,2) -- 营业收入(万元)
    ,cpp_yotal_asset number(18,2) -- 资产总额
    ,cpp_employees varchar2(30) -- 从业人员(人)
    ,cpp_fctv_date varchar2(12) -- 营业期限（自）
    ,cpp_xpry_date varchar2(12) -- 营业期限（至）
    ,cpp_busi_scope varchar2(4000) -- 经营范围
    ,cpp_note varchar2(675) -- 企业备注
    ,cpp_agent_name varchar2(90) -- 经办人名称
    ,cpp_agent_no varchar2(90) -- 经办人身份证号
    ,cpp_agent_tel varchar2(90) -- 经办人电话
    ,cpp_agent_email varchar2(338) -- 经办人邮箱
    ,cpp_legal_name varchar2(90) -- 法定代表人姓名
    ,cpp_legal_nation varchar2(90) -- 法定代表人国籍
    ,cpp_doc_type varchar2(90) -- 法定代表人证件类型
    ,cpp_legal_no varchar2(90) -- 法定代表人证件号码
    ,cpp_legal_doc_date varchar2(12) -- 法定代表人证件签发日期
    ,cpp_legal_docdue_date varchar2(12) -- 法定代表人证件到期日期
    ,cpp_legal_doc_city varchar2(675) -- 法定代表人证件签发城市
    ,cpp_inv_type varchar2(6) -- 发票种类
    ,cpp_tax_type varchar2(6) -- 纳税人类别
    ,cpp_tax_tel varchar2(9) -- 纳税人电话
    ,cpp_tax_bank_name varchar2(675) -- 纳税人开户行名
    ,cpp_tax_bank_no varchar2(48) -- 纳税人帐号
    ,is_need_inv varchar2(2) -- 是否需要开票
    ,cpp_tax_name varchar2(675) -- 纳税人名称
    ,cpp_taxer_code varchar2(30) -- 纳税人识别号
    ,cpp_taxer_adr varchar2(450) -- 纳税人地址
    ,create_by varchar2(45) -- 创建人
    ,create_time varchar2(21) -- 鍒涘缓鏃堕棿
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
grant select on ${iol_schema}.bdms_cpp_cust_register_info to ${iml_schema};
grant select on ${iol_schema}.bdms_cpp_cust_register_info to ${icl_schema};
grant select on ${iol_schema}.bdms_cpp_cust_register_info to ${idl_schema};
grant select on ${iol_schema}.bdms_cpp_cust_register_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpp_cust_register_info is '贴现通登记申请信息表';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.id is 'ID';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.busi_id is '业务表ID';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.busi_type is '业务类型： 300 登记 301 解除登记';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.opr_type is '操作类型： AT01 新增 AT02 修改 AT99 查询';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.reg_brh_no is '登记机构代码';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_cust_name is '申请人名称';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_social_no is '申请人社会信用代码';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_corp_scale is '规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_ind_cls is '行业分类：详见概述分册';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_arc_flag is '是否涉农企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_grn_flag is '是否绿色企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_sci_flag is '是否科技企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_pop_flag is '是否民营企业： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_province is '贴现申请人省份：参见附录省份代码';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.reg_status is '登记状态： DRS01 正常 DRS02 失效';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.process_code is '处理码';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.process_msg is '处理信息';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.misc is '备注';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_signature is '中证码';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_address is '住所/地址';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_ctgy is '类型';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_corp_type is '企业所有制形式';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_reg_cap is '注册资本(万元)';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_busi_in is '营业收入(万元)';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_yotal_asset is '资产总额';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_employees is '从业人员(人)';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_fctv_date is '营业期限（自）';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_xpry_date is '营业期限（至）';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_busi_scope is '经营范围';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_note is '企业备注';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_agent_name is '经办人名称';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_agent_no is '经办人身份证号';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_agent_tel is '经办人电话';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_agent_email is '经办人邮箱';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_legal_name is '法定代表人姓名';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_legal_nation is '法定代表人国籍';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_doc_type is '法定代表人证件类型';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_legal_no is '法定代表人证件号码';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_legal_doc_date is '法定代表人证件签发日期';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_legal_docdue_date is '法定代表人证件到期日期';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_legal_doc_city is '法定代表人证件签发城市';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_inv_type is '发票种类';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_tax_type is '纳税人类别';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_tax_tel is '纳税人电话';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_tax_bank_name is '纳税人开户行名';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_tax_bank_no is '纳税人帐号';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.is_need_inv is '是否需要开票';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_tax_name is '纳税人名称';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_taxer_code is '纳税人识别号';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.cpp_taxer_adr is '纳税人地址';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.create_time is '鍒涘缓鏃堕棿';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpp_cust_register_info.etl_timestamp is 'ETL处理时间戳';
