/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_customer_maintain
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_customer_maintain
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_customer_maintain purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_customer_maintain(
    id varchar2(60) -- 主键ID
    ,top_branch_no varchar2(30) -- 总行机构号
    ,branch_no varchar2(30) -- 机构号
    ,cust_info_id varchar2(60) -- 贴现申请人信息ID
    ,cpp_cust_no varchar2(30) -- 贴现通申请人客户号
    ,cpp_cust_name varchar2(270) -- 贴现通申请人客户名称
    ,cpp_social_no varchar2(27) -- 贴现通申请人社会信用代码
    ,cpp_reg_brh varchar2(15) -- 贴现通申请人登记机构
    ,cpp_status varchar2(8) -- 状态： DRS01 正常 DRS02 失效
    ,cpp_corp_scale varchar2(6) -- 规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他
    ,cpp_ind_cls varchar2(8) -- 行业分类：详见概述
    ,cpp_arc_flag varchar2(2) -- 是否涉农企业: 0 否 1 是
    ,cpp_grn_flag varchar2(2) -- 是否绿色企业: 0 否 1 是
    ,cpp_sci_flag varchar2(2) -- 是否科技企业: 0 否 1 是
    ,cpp_pop_flag varchar2(2) -- 是否民营企业: 0 否 1 是
    ,cpp_province varchar2(3) -- 省份：参见附录省份代码
    ,contract_no varchar2(60) -- 批次号
    ,product_no varchar2(12) -- 产品号
    ,busi_type varchar2(5) -- 业务类型： 300 贴现申请人登记 301 贴现申请人解除登记
    ,contract_status varchar2(3) -- 审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝
    ,message_status varchar2(3) -- 报文状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败
    ,src_type varchar2(3) -- 来源类型： 00 机构端 01 网银端 02 数据导入
    ,channel_flow_no varchar2(60) -- 渠道流水号
    ,process_code varchar2(14) -- 处理码
    ,process_msg varchar2(768) -- 处理信息
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
    ,cpp_tax_tel varchar2(30) -- 纳税人电话
    ,cpp_tax_bank_name varchar2(675) -- 纳税人开户行名
    ,cpp_tax_bank_no varchar2(48) -- 纳税人帐号
    ,is_need_inv varchar2(2) -- 是否需要开票
    ,cpp_tax_name varchar2(675) -- 纳税人名称
    ,cpp_taxer_code varchar2(30) -- 纳税人识别号
    ,cpp_taxer_adr varchar2(450) -- 纳税人地址
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
grant select on ${iol_schema}.bdms_cpes_customer_maintain to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_customer_maintain to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_customer_maintain to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_customer_maintain to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_customer_maintain is '贴现通申请人信息维护表';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.id is '主键ID';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.branch_no is '机构号';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cust_info_id is '贴现申请人信息ID';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_cust_no is '贴现通申请人客户号';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_cust_name is '贴现通申请人客户名称';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_social_no is '贴现通申请人社会信用代码';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_reg_brh is '贴现通申请人登记机构';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_status is '状态： DRS01 正常 DRS02 失效';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_corp_scale is '规模： SC00 大型企业 SC01 中型企业 SC02 小型企业 SC03 微小企业 SC04 其他';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_ind_cls is '行业分类：详见概述';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_arc_flag is '是否涉农企业: 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_grn_flag is '是否绿色企业: 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_sci_flag is '是否科技企业: 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_pop_flag is '是否民营企业: 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_province is '省份：参见附录省份代码';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.contract_no is '批次号';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.product_no is '产品号';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.busi_type is '业务类型： 300 贴现申请人登记 301 贴现申请人解除登记';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.contract_status is '审批状态： 00 未提交 01 审批中 02 审批完成 03 审批退回 04 审批拒绝';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.message_status is '报文状态： 00 未处理 10 发送中 11 发送成功 12 发送确认成功 13 发送确认失败 14 发送已收到应答 21 撤回中 22 撤回成功 23 撤回失败 30 应答中 31 应答成功 32 应答确认成功 33 应答确认失败';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.src_type is '来源类型： 00 机构端 01 网银端 02 数据导入';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.channel_flow_no is '渠道流水号';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.process_code is '处理码';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.process_msg is '处理信息';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.last_upd_opr is '最后操作员';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.misc is '备注';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_signature is '中证码';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_address is '住所/地址';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_ctgy is '类型';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_corp_type is '企业所有制形式';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_reg_cap is '注册资本(万元)';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_busi_in is '营业收入(万元)';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_yotal_asset is '资产总额';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_employees is '从业人员(人)';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_fctv_date is '营业期限（自）';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_xpry_date is '营业期限（至）';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_busi_scope is '经营范围';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_note is '企业备注';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_agent_name is '经办人名称';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_agent_no is '经办人身份证号';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_agent_tel is '经办人电话';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_agent_email is '经办人邮箱';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_legal_name is '法定代表人姓名';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_legal_nation is '法定代表人国籍';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_doc_type is '法定代表人证件类型';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_legal_no is '法定代表人证件号码';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_legal_doc_date is '法定代表人证件签发日期';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_legal_docdue_date is '法定代表人证件到期日期';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_legal_doc_city is '法定代表人证件签发城市';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_inv_type is '发票种类';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_tax_type is '纳税人类别';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_tax_tel is '纳税人电话';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_tax_bank_name is '纳税人开户行名';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_tax_bank_no is '纳税人帐号';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.is_need_inv is '是否需要开票';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_tax_name is '纳税人名称';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_taxer_code is '纳税人识别号';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.cpp_taxer_adr is '纳税人地址';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_customer_maintain.etl_timestamp is 'ETL处理时间戳';
