/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_pre_corporate_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_pre_corporate_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_pre_corporate_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_pre_corporate_tb(
    id varchar2(36) -- 唯一主键
    ,task_id varchar2(50) -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
    ,glob_seq_num varchar2(33) -- 全局流水号（取ESC）
    ,organ_no varchar2(50) -- 交易机构号（取ESC）
    ,pretrial_status varchar2(1) -- 预审状态（0-预审已受理，1-预审通过，2-预审不通过，3-已超期，4-已作废，5-审批中，6-已结束）
    ,pre_acpt_id varchar2(50) -- 预受理编号
    ,pre_date date -- 受理日期
    ,chn_encd varchar2(6) -- 304002微信，301003企业网银  (渠道)
    ,papers_type varchar2(4) -- 证件类型
    ,papers_number varchar2(60) -- 证件号码
    ,cust_no varchar2(16) -- 客户编号
    ,cust_name varchar2(200) -- 客户名称
    ,acct_prop varchar2(10) -- 账户性质
    ,acct_name varchar2(200) -- 账户名称
    ,acct_no varchar2(50) -- 账号
    ,appoint_num varchar2(50) -- 预受理次数
    ,prec_typ varchar2(1) -- 预约类型(0-我要预约 1-我在现场)
    ,prec_biz varchar2(100) -- 预约业务
    ,reserv_begin_time date -- 预约开始时间
    ,reserv_end_time date -- 预约结束时间
    ,pre_business_name varchar2(200) -- 预受理业务名称（对公预受理）
    ,blip_id varchar2(50) -- 影像批次号
    ,pre_branch_code varchar2(20) -- 受理机构
    ,acct_seq_no varchar2(50) -- 开户流水号
    ,copr_name varchar2(200) -- 工作单位名称
    ,per_scope varchar2(4000) -- 经营范围
    ,cert_valid_dt date -- 证件生效日期
    ,org_crdt_cd_cert_num varchar2(50) -- 证明文件编号
    ,prod_loc varchar2(400) -- 注册地址
    ,enro_cap number(20,2) -- 注册资本
    ,fr_name varchar2(200) -- 法人姓名
    ,fr_cert_typ varchar2(60) -- 法人证件号码
    ,fr_cert_due_dt date -- 有效期
    ,contact_name varchar2(200) -- 联系人名称
    ,cust_phone varchar2(30) -- 电话号码
    ,blacklist_result varchar2(100) -- 黑名单查证结果
    ,bank_code_result varchar2(100) -- 银码查证结果
    ,remark varchar2(200) -- 备注
    ,pre_time date -- 受理时间
    ,pre_acpt_status varchar2(6) -- 预受理状态(0 进行中 1 已完成 )
    ,state varchar2(6) -- 业务状态（1.处理中 2.记账完成 3.记账失败 4.业务终止 5.已冲正 ）
    ,scan_date date -- 影像扫描日期
    ,prec_brch varchar2(30) -- 预约网点
    ,promt_prio varchar2(10) -- 提升优先级
    ,blip_model varchar2(10) -- 影像模型
    ,temp_acct_valid_dt date -- 临时户有效日期
    ,vouch_group varchar2(32) -- 业务场景凭证组合
    ,lp_cert_due_dt date -- 法人到期日
    ,order_id varchar2(32) -- 订单编号
    ,init_tm date -- 发起时间
    ,acct_purp varchar2(10) -- 账户用途 用于表示账户开立的账户用途
    ,acct_type varchar2(10) -- 账户种类 00-无特殊用途 11-预算单位专用 12-非预算单位专用
    ,cert_type varchar2(10) -- 证件类型
    ,check_sell_can varchar2(10) -- 支票出售许可
    ,dpstr_name varchar2(20) -- 存款人名称
    ,dps_type varchar2(10) -- 储种 A01:单位活期,A05:财政存款,A06:临时存款,A09:活期同业存款
    ,fx_acct_rpt varchar2(50) -- 外汇账户报送
    ,indu_class_encd varchar2(20) -- 行业分类编码
    ,limit_ref varchar2(20) -- 限额编码
    ,local_tax_reg_cert_num varchar2(50) -- 地税登记证号
    ,main_acct varchar2(50) -- 主账号
    ,major_category varchar2(3) -- 存款人类别
    ,max_lmt varchar2(10) -- 最大限额
    ,mobile_no varchar2(30) -- 电话号码
    ,nation_tax_reg_cert_num varchar2(50) -- 国税登记证号
    ,new_fx_proj varchar2(10) -- 新外汇项目
    ,nra_flag varchar2(1) -- NRA标识 0-否  1-是
    ,reg_loc varchar2(200) -- 注册地址
    ,sec_doc_due_day varchar2(8) -- 第二证件到期日
    ,sec_doc_num varchar2(50) -- 第二证件号码
    ,sec_doc_typ varchar2(10) -- 第二证件类型
    ,stl_cd varchar2(10) -- 核算代码
    ,super_document_id varchar2(50) -- 上级法人或单位负责人证件号码
    ,super_document_type varchar2(20) -- 上级法人或单位负责人证件种类
    ,super_lp_or_dirt_corp_name varchar2(200) -- 上级法人或主管单位名称
    ,super_name varchar2(50) -- 上级法人或单位负责人姓名
    ,wthr_lmt varchar2(1) -- 是否限额 0-否，1-是
    ,wthr_shar_seal varchar2(1) -- 是否共用印鉴 0-否，1-是
    ,zipcode varchar2(20) -- 邮政编码
    ,zone_cd varchar2(10) -- 地区代码
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
grant select on ${iol_schema}.scps_bp_pre_corporate_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_pre_corporate_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_pre_corporate_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_pre_corporate_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_pre_corporate_tb is '对公预受理表';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.id is '唯一主键';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.task_id is '任务号(集中作业取ESC订单号，远程授权放授权任务号)';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.glob_seq_num is '全局流水号（取ESC）';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.organ_no is '交易机构号（取ESC）';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.pretrial_status is '预审状态（0-预审已受理，1-预审通过，2-预审不通过，3-已超期，4-已作废，5-审批中，6-已结束）';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.pre_acpt_id is '预受理编号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.pre_date is '受理日期';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.chn_encd is '304002微信，301003企业网银  (渠道)';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.papers_type is '证件类型';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.papers_number is '证件号码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.cust_no is '客户编号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.cust_name is '客户名称';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.acct_prop is '账户性质';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.acct_name is '账户名称';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.acct_no is '账号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.appoint_num is '预受理次数';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.prec_typ is '预约类型(0-我要预约 1-我在现场)';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.prec_biz is '预约业务';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.reserv_begin_time is '预约开始时间';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.reserv_end_time is '预约结束时间';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.pre_business_name is '预受理业务名称（对公预受理）';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.blip_id is '影像批次号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.pre_branch_code is '受理机构';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.acct_seq_no is '开户流水号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.copr_name is '工作单位名称';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.per_scope is '经营范围';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.cert_valid_dt is '证件生效日期';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.org_crdt_cd_cert_num is '证明文件编号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.prod_loc is '注册地址';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.enro_cap is '注册资本';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.fr_name is '法人姓名';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.fr_cert_typ is '法人证件号码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.fr_cert_due_dt is '有效期';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.contact_name is '联系人名称';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.cust_phone is '电话号码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.blacklist_result is '黑名单查证结果';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.bank_code_result is '银码查证结果';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.remark is '备注';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.pre_time is '受理时间';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.pre_acpt_status is '预受理状态(0 进行中 1 已完成 )';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.state is '业务状态（1.处理中 2.记账完成 3.记账失败 4.业务终止 5.已冲正 ）';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.scan_date is '影像扫描日期';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.prec_brch is '预约网点';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.promt_prio is '提升优先级';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.blip_model is '影像模型';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.temp_acct_valid_dt is '临时户有效日期';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.vouch_group is '业务场景凭证组合';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.lp_cert_due_dt is '法人到期日';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.order_id is '订单编号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.init_tm is '发起时间';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.acct_purp is '账户用途 用于表示账户开立的账户用途';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.acct_type is '账户种类 00-无特殊用途 11-预算单位专用 12-非预算单位专用';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.cert_type is '证件类型';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.check_sell_can is '支票出售许可';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.dpstr_name is '存款人名称';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.dps_type is '储种 A01:单位活期,A05:财政存款,A06:临时存款,A09:活期同业存款';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.fx_acct_rpt is '外汇账户报送';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.indu_class_encd is '行业分类编码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.limit_ref is '限额编码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.local_tax_reg_cert_num is '地税登记证号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.main_acct is '主账号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.major_category is '存款人类别';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.max_lmt is '最大限额';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.mobile_no is '电话号码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.nation_tax_reg_cert_num is '国税登记证号';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.new_fx_proj is '新外汇项目';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.nra_flag is 'NRA标识 0-否  1-是';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.reg_loc is '注册地址';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.sec_doc_due_day is '第二证件到期日';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.sec_doc_num is '第二证件号码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.sec_doc_typ is '第二证件类型';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.stl_cd is '核算代码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.super_document_id is '上级法人或单位负责人证件号码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.super_document_type is '上级法人或单位负责人证件种类';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.super_lp_or_dirt_corp_name is '上级法人或主管单位名称';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.super_name is '上级法人或单位负责人姓名';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.wthr_lmt is '是否限额 0-否，1-是';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.wthr_shar_seal is '是否共用印鉴 0-否，1-是';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.zipcode is '邮政编码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.zone_cd is '地区代码';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_pre_corporate_tb.etl_timestamp is 'ETL处理时间戳';
