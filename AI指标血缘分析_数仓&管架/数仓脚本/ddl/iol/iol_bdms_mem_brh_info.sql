/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_mem_brh_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_mem_brh_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_mem_brh_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_mem_brh_info(
    id varchar2(60) -- ID
    ,mem_no varchar2(9) -- 会员代码
    ,brh_no varchar2(14) -- 机构代码
    ,brh_code varchar2(32) -- 机构编码
    ,brh_type varchar2(2) -- 机构类别代码： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者
    ,brh_class varchar2(5) -- 机构类型代码：见中国票据交易系统直连接口规范【概述分册】的数据类型BranchClass
    ,brh_zh_full_name varchar2(450) -- 机构全称（中文）
    ,brh_en_full_name varchar2(300) -- 机构全称（英文）
    ,brh_zh_short_name varchar2(270) -- 机构简称（中文）
    ,brh_en_short_name varchar2(135) -- 机构简称（英文）
    ,social_credit_no varchar2(27) -- 统一社会信用代码
    ,province_no varchar2(3) -- 省份代码：见中国票据交易系统直连接口规范【概述分册】的数据类型Province
    ,br_corp_class varchar2(6) -- 法人级别代码： CC00 法人(含虚拟资管参与者) CC01 分支机构 CC02 非法人产品
    ,brh_level varchar2(2) -- 机构层级
    ,pro_effect_date varchar2(15) -- 产品有效日期
    ,pro_expire_date varchar2(15) -- 产品失效日期
    ,brh_status varchar2(6) -- 机构状态： ST01 活动 ST02 禁用 ST03 注销
    ,brh_acct_name varchar2(135) -- 机构内部账户名称
    ,brh_acct_no varchar2(48) -- 机构内部账户账号
    ,txn_acct_no varchar2(48) -- 交易账号
    ,txn_acct_status varchar2(6) -- 交易账户状态： ST01 活动 ST02 禁用 ST03 注销
    ,reg_acct_no varchar2(48) -- 托管账号 托管账户状态: ST01 活动 ST02 禁用
    ,reg_acct_status varchar2(6) -- 托管账户状态: ST01 活动 ST02 禁用 ST03 注销
    ,cap_acct_no varchar2(48) -- 票交所资金账户账号
    ,cap_acct_status varchar2(6) -- 票交所资金账户状态: ST01 活动 ST02 禁用 ST03 注销
    ,corp_represence varchar2(270) -- 法定代表人或负责人
    ,withdraw_bank_no varchar2(18) -- 出金账户开户行大额支付系统行号
    ,withdraw_acct_name varchar2(225) -- 出金账户名称
    ,withdraw_acct_no varchar2(48) -- 出金账户账号
    ,registered_capital number(15,2) -- 注册资本
    ,adress varchar2(450) -- 地址
    ,attn varchar2(90) -- 联系人
    ,tel varchar2(30) -- 联系电话
    ,fax_code varchar2(30) -- 传真
    ,post_code varchar2(9) -- 邮编
    ,misc varchar2(675) -- 备注
    ,ubank_no varchar2(18) -- 系统参与者大额行号
    ,ubank_name varchar2(450) -- 系统参与者大额行名
    ,agency_ubank_no varchar2(18) -- 电票代理行大额行号
    ,agency_ubank_acct varchar2(48) -- 电票代理行大额账号
    ,authority_list varchar2(4000) -- 机构权限列表
    ,recept_brh_id varchar2(14) -- 承接机构代码
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,head_brh_type varchar2(2) -- 总行类别： 1 国股 2 城商
    ,create_time varchar2(12) -- 创建时间
    ,last_upd_opr varchar2(12) -- 最后更新人
    ,create_by varchar2(12) -- 创建人
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
grant select on ${iol_schema}.bdms_mem_brh_info to ${iml_schema};
grant select on ${iol_schema}.bdms_mem_brh_info to ${icl_schema};
grant select on ${iol_schema}.bdms_mem_brh_info to ${idl_schema};
grant select on ${iol_schema}.bdms_mem_brh_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_mem_brh_info is '会员机构信息表';
comment on column ${iol_schema}.bdms_mem_brh_info.id is 'ID';
comment on column ${iol_schema}.bdms_mem_brh_info.mem_no is '会员代码';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_no is '机构代码';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_code is '机构编码';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_type is '机构类别代码： 1 中央银行 2 银行类机构 3 非银行类金融机构 4 非法人产品 5 虚拟资管参与者 6 非金融机构 7 存托类非法人产品 8 存托类虚拟系统参与者';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_class is '机构类型代码：见中国票据交易系统直连接口规范【概述分册】的数据类型BranchClass';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_zh_full_name is '机构全称（中文）';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_en_full_name is '机构全称（英文）';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_zh_short_name is '机构简称（中文）';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_en_short_name is '机构简称（英文）';
comment on column ${iol_schema}.bdms_mem_brh_info.social_credit_no is '统一社会信用代码';
comment on column ${iol_schema}.bdms_mem_brh_info.province_no is '省份代码：见中国票据交易系统直连接口规范【概述分册】的数据类型Province';
comment on column ${iol_schema}.bdms_mem_brh_info.br_corp_class is '法人级别代码： CC00 法人(含虚拟资管参与者) CC01 分支机构 CC02 非法人产品';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_level is '机构层级';
comment on column ${iol_schema}.bdms_mem_brh_info.pro_effect_date is '产品有效日期';
comment on column ${iol_schema}.bdms_mem_brh_info.pro_expire_date is '产品失效日期';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_status is '机构状态： ST01 活动 ST02 禁用 ST03 注销';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_acct_name is '机构内部账户名称';
comment on column ${iol_schema}.bdms_mem_brh_info.brh_acct_no is '机构内部账户账号';
comment on column ${iol_schema}.bdms_mem_brh_info.txn_acct_no is '交易账号';
comment on column ${iol_schema}.bdms_mem_brh_info.txn_acct_status is '交易账户状态： ST01 活动 ST02 禁用 ST03 注销';
comment on column ${iol_schema}.bdms_mem_brh_info.reg_acct_no is '托管账号 托管账户状态: ST01 活动 ST02 禁用';
comment on column ${iol_schema}.bdms_mem_brh_info.reg_acct_status is '托管账户状态: ST01 活动 ST02 禁用 ST03 注销';
comment on column ${iol_schema}.bdms_mem_brh_info.cap_acct_no is '票交所资金账户账号';
comment on column ${iol_schema}.bdms_mem_brh_info.cap_acct_status is '票交所资金账户状态: ST01 活动 ST02 禁用 ST03 注销';
comment on column ${iol_schema}.bdms_mem_brh_info.corp_represence is '法定代表人或负责人';
comment on column ${iol_schema}.bdms_mem_brh_info.withdraw_bank_no is '出金账户开户行大额支付系统行号';
comment on column ${iol_schema}.bdms_mem_brh_info.withdraw_acct_name is '出金账户名称';
comment on column ${iol_schema}.bdms_mem_brh_info.withdraw_acct_no is '出金账户账号';
comment on column ${iol_schema}.bdms_mem_brh_info.registered_capital is '注册资本';
comment on column ${iol_schema}.bdms_mem_brh_info.adress is '地址';
comment on column ${iol_schema}.bdms_mem_brh_info.attn is '联系人';
comment on column ${iol_schema}.bdms_mem_brh_info.tel is '联系电话';
comment on column ${iol_schema}.bdms_mem_brh_info.fax_code is '传真';
comment on column ${iol_schema}.bdms_mem_brh_info.post_code is '邮编';
comment on column ${iol_schema}.bdms_mem_brh_info.misc is '备注';
comment on column ${iol_schema}.bdms_mem_brh_info.ubank_no is '系统参与者大额行号';
comment on column ${iol_schema}.bdms_mem_brh_info.ubank_name is '系统参与者大额行名';
comment on column ${iol_schema}.bdms_mem_brh_info.agency_ubank_no is '电票代理行大额行号';
comment on column ${iol_schema}.bdms_mem_brh_info.agency_ubank_acct is '电票代理行大额账号';
comment on column ${iol_schema}.bdms_mem_brh_info.authority_list is '机构权限列表';
comment on column ${iol_schema}.bdms_mem_brh_info.recept_brh_id is '承接机构代码';
comment on column ${iol_schema}.bdms_mem_brh_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_mem_brh_info.head_brh_type is '总行类别： 1 国股 2 城商';
comment on column ${iol_schema}.bdms_mem_brh_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_mem_brh_info.last_upd_opr is '最后更新人';
comment on column ${iol_schema}.bdms_mem_brh_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_mem_brh_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_mem_brh_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_mem_brh_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_mem_brh_info.etl_timestamp is 'ETL处理时间戳';
