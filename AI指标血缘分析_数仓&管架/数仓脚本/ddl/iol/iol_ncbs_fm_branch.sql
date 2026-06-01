/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_branch
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_branch
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_branch purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_branch(
    area_code varchar2(6) -- 地区码
    ,branch varchar2(12) -- 机构编号
    ,branch_name varchar2(200) -- 银行机构名称
    ,country varchar2(3) -- 国家
    ,profit_center varchar2(20) -- 利润中心
    ,abnormal_open_control varchar2(1) -- 非正常时间开门控制方式
    ,auth_flag varchar2(1) -- 授权标志
    ,branch_short varchar2(30) -- 机构简称
    ,branch_status varchar2(1) -- 机构开关门状态
    ,branch_type varchar2(1) -- 机构类型
    ,cheque_issuing_branch_flag varchar2(1) -- 是否签发支票
    ,city varchar2(6) -- 行政区划(城市)
    ,company varchar2(20) -- 法人
    ,default_teller_login varchar2(1) -- 默认柜员登录认证方式
    ,district varchar2(10) -- 区号
    ,eod_flag varchar2(1) -- 日终标识
    ,fta_code varchar2(10) -- 自贸区代码
    ,fta_flag varchar2(1) -- 是否自贸区机构
    ,fx_organ_code varchar2(12) -- 外汇金融机构代码
    ,index_str varchar2(200) -- 索引字符串
    ,int_tax_levy varchar2(1) -- 利息税征收标志
    ,ip_addr varchar2(200) -- 机构ip地址
    ,oper_max_level varchar2(5) -- 操作最高级别
    ,pboc_fund_check_flag varchar2(1) -- 人行备付金检查标志
    ,postal_code varchar2(10) -- 邮政编码
    ,state varchar2(6) -- 行政区划(省、州)
    ,surtax_type varchar2(30) -- 附加税类型
    ,tailbox_detach_flag varchar2(1) -- 尾箱控制方式
    ,voucher_user_contral_flag varchar2(1) -- 是否限制凭证入库柜员
    ,accounting_branch varchar2(12) -- 核算机构
    ,libra_op_time number(15) -- libra执行次数
    ,create_date date -- 创建日期
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,attached_to varchar2(12) -- 所属上级
    ,base_ccy varchar2(3) -- 基础币种
    ,ccy_ctrl_branch varchar2(12) -- 结售汇平盘机构
    ,cny_business_unit varchar2(10) -- 账套(人民币)
    ,hierarchy_code varchar2(2) -- 机构级别
    ,hkd_business_unit varchar2(10) -- 账套(港币)
    ,internal_client varchar2(16) -- 内部客户号
    ,local_ccy varchar2(3) -- 当地币种
    ,sub_branch_code varchar2(12) -- 分行代码
    ,tax_rpt_branch varchar2(12) -- 税收机构（总账用）
    ,tran_br_ind varchar2(1) -- 是否交易机构
    ,accounting_branch_flag varchar2(1) -- 是否核算机构
    ,normal_close_time varchar2(8) -- 正常关门时间
    ,normal_open_time varchar2(8) -- 正常开门时间
    ,pboc_financing_no varchar2(30) -- 人行金融机构编码
    ,branch_en_short varchar2(30) -- 机构英文简称
    ,branch_head_phone varchar2(30) -- 机构负责人联系电话
    ,pboc_pay_branch_no varchar2(12) -- 人行支付行号
    ,is_auto_create_internal_acct varchar2(1) -- 是否自动开立内部户
    ,branch_en_name varchar2(200) -- 机构英文名称
    ,pboc_area_code varchar2(50) -- 人行地区代码
    ,branch_head_name varchar2(50) -- 机构负责人姓名
    ,branch_close_date date -- 关闭日期
    ,branch_head_duty varchar2(50) -- 机构负责人职务
    ,swift_no varchar2(50) -- swift号
    ,cup_financing_no varchar2(50) -- 银联金融机构编号
    ,pboc_acct_manage_sys_no varchar2(50) -- 人行账户管理系统行号
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
grant select on ${iol_schema}.ncbs_fm_branch to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_branch to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_branch to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_branch to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_branch is '机构信息表';
comment on column ${iol_schema}.ncbs_fm_branch.area_code is '地区码';
comment on column ${iol_schema}.ncbs_fm_branch.branch is '机构编号';
comment on column ${iol_schema}.ncbs_fm_branch.branch_name is '银行机构名称';
comment on column ${iol_schema}.ncbs_fm_branch.country is '国家';
comment on column ${iol_schema}.ncbs_fm_branch.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_fm_branch.abnormal_open_control is '非正常时间开门控制方式';
comment on column ${iol_schema}.ncbs_fm_branch.auth_flag is '授权标志';
comment on column ${iol_schema}.ncbs_fm_branch.branch_short is '机构简称';
comment on column ${iol_schema}.ncbs_fm_branch.branch_status is '机构开关门状态';
comment on column ${iol_schema}.ncbs_fm_branch.branch_type is '机构类型';
comment on column ${iol_schema}.ncbs_fm_branch.cheque_issuing_branch_flag is '是否签发支票';
comment on column ${iol_schema}.ncbs_fm_branch.city is '行政区划(城市)';
comment on column ${iol_schema}.ncbs_fm_branch.company is '法人';
comment on column ${iol_schema}.ncbs_fm_branch.default_teller_login is '默认柜员登录认证方式';
comment on column ${iol_schema}.ncbs_fm_branch.district is '区号';
comment on column ${iol_schema}.ncbs_fm_branch.eod_flag is '日终标识';
comment on column ${iol_schema}.ncbs_fm_branch.fta_code is '自贸区代码';
comment on column ${iol_schema}.ncbs_fm_branch.fta_flag is '是否自贸区机构';
comment on column ${iol_schema}.ncbs_fm_branch.fx_organ_code is '外汇金融机构代码';
comment on column ${iol_schema}.ncbs_fm_branch.index_str is '索引字符串';
comment on column ${iol_schema}.ncbs_fm_branch.int_tax_levy is '利息税征收标志';
comment on column ${iol_schema}.ncbs_fm_branch.ip_addr is '机构ip地址';
comment on column ${iol_schema}.ncbs_fm_branch.oper_max_level is '操作最高级别';
comment on column ${iol_schema}.ncbs_fm_branch.pboc_fund_check_flag is '人行备付金检查标志';
comment on column ${iol_schema}.ncbs_fm_branch.postal_code is '邮政编码';
comment on column ${iol_schema}.ncbs_fm_branch.state is '行政区划(省、州)';
comment on column ${iol_schema}.ncbs_fm_branch.surtax_type is '附加税类型';
comment on column ${iol_schema}.ncbs_fm_branch.tailbox_detach_flag is '尾箱控制方式';
comment on column ${iol_schema}.ncbs_fm_branch.voucher_user_contral_flag is '是否限制凭证入库柜员';
comment on column ${iol_schema}.ncbs_fm_branch.accounting_branch is '核算机构';
comment on column ${iol_schema}.ncbs_fm_branch.libra_op_time is 'libra执行次数';
comment on column ${iol_schema}.ncbs_fm_branch.create_date is '创建日期';
comment on column ${iol_schema}.ncbs_fm_branch.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_fm_branch.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_fm_branch.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_branch.attached_to is '所属上级';
comment on column ${iol_schema}.ncbs_fm_branch.base_ccy is '基础币种';
comment on column ${iol_schema}.ncbs_fm_branch.ccy_ctrl_branch is '结售汇平盘机构';
comment on column ${iol_schema}.ncbs_fm_branch.cny_business_unit is '账套(人民币)';
comment on column ${iol_schema}.ncbs_fm_branch.hierarchy_code is '机构级别';
comment on column ${iol_schema}.ncbs_fm_branch.hkd_business_unit is '账套(港币)';
comment on column ${iol_schema}.ncbs_fm_branch.internal_client is '内部客户号';
comment on column ${iol_schema}.ncbs_fm_branch.local_ccy is '当地币种';
comment on column ${iol_schema}.ncbs_fm_branch.sub_branch_code is '分行代码';
comment on column ${iol_schema}.ncbs_fm_branch.tax_rpt_branch is '税收机构（总账用）';
comment on column ${iol_schema}.ncbs_fm_branch.tran_br_ind is '是否交易机构';
comment on column ${iol_schema}.ncbs_fm_branch.accounting_branch_flag is '是否核算机构';
comment on column ${iol_schema}.ncbs_fm_branch.normal_close_time is '正常关门时间';
comment on column ${iol_schema}.ncbs_fm_branch.normal_open_time is '正常开门时间';
comment on column ${iol_schema}.ncbs_fm_branch.pboc_financing_no is '人行金融机构编码';
comment on column ${iol_schema}.ncbs_fm_branch.branch_en_short is '机构英文简称';
comment on column ${iol_schema}.ncbs_fm_branch.branch_head_phone is '机构负责人联系电话';
comment on column ${iol_schema}.ncbs_fm_branch.pboc_pay_branch_no is '人行支付行号';
comment on column ${iol_schema}.ncbs_fm_branch.is_auto_create_internal_acct is '是否自动开立内部户';
comment on column ${iol_schema}.ncbs_fm_branch.branch_en_name is '机构英文名称';
comment on column ${iol_schema}.ncbs_fm_branch.pboc_area_code is '人行地区代码';
comment on column ${iol_schema}.ncbs_fm_branch.branch_head_name is '机构负责人姓名';
comment on column ${iol_schema}.ncbs_fm_branch.branch_close_date is '关闭日期';
comment on column ${iol_schema}.ncbs_fm_branch.branch_head_duty is '机构负责人职务';
comment on column ${iol_schema}.ncbs_fm_branch.swift_no is 'swift号';
comment on column ${iol_schema}.ncbs_fm_branch.cup_financing_no is '银联金融机构编号';
comment on column ${iol_schema}.ncbs_fm_branch.pboc_acct_manage_sys_no is '人行账户管理系统行号';
comment on column ${iol_schema}.ncbs_fm_branch.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_branch.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_branch.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_branch.etl_timestamp is 'ETL处理时间戳';
