/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_bp_pre_corporate_tb
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.scps_bp_pre_corporate_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_bp_pre_corporate_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_pre_corporate_tb_op purge;
drop table ${iol_schema}.scps_bp_pre_corporate_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_pre_corporate_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_pre_corporate_tb where 0=1;

create table ${iol_schema}.scps_bp_pre_corporate_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_bp_pre_corporate_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_pre_corporate_tb_cl(
            id -- 唯一主键
            ,task_id -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
            ,glob_seq_num -- 全局流水号（取ESC）
            ,organ_no -- 交易机构号（取ESC）
            ,pretrial_status -- 预审状态（0-预审已受理，1-预审通过，2-预审不通过，3-已超期，4-已作废，5-审批中，6-已结束）
            ,pre_acpt_id -- 预受理编号
            ,pre_date -- 受理日期
            ,chn_encd -- 304002微信，301003企业网银  (渠道)
            ,papers_type -- 证件类型
            ,papers_number -- 证件号码
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,acct_prop -- 账户性质
            ,acct_name -- 账户名称
            ,acct_no -- 账号
            ,appoint_num -- 预受理次数
            ,prec_typ -- 预约类型(0-我要预约 1-我在现场)
            ,prec_biz -- 预约业务
            ,reserv_begin_time -- 预约开始时间
            ,reserv_end_time -- 预约结束时间
            ,pre_business_name -- 预受理业务名称（对公预受理）
            ,blip_id -- 影像批次号
            ,pre_branch_code -- 受理机构
            ,acct_seq_no -- 开户流水号
            ,copr_name -- 工作单位名称
            ,per_scope -- 经营范围
            ,cert_valid_dt -- 证件生效日期
            ,org_crdt_cd_cert_num -- 证明文件编号
            ,prod_loc -- 注册地址
            ,enro_cap -- 注册资本
            ,fr_name -- 法人姓名
            ,fr_cert_typ -- 法人证件号码
            ,fr_cert_due_dt -- 有效期
            ,contact_name -- 联系人名称
            ,cust_phone -- 电话号码
            ,blacklist_result -- 黑名单查证结果
            ,bank_code_result -- 银码查证结果
            ,remark -- 备注
            ,pre_time -- 受理时间
            ,pre_acpt_status -- 预受理状态(0 进行中 1 已完成 )
            ,state -- 业务状态（1.处理中 2.记账完成 3.记账失败 4.业务终止 5.已冲正 ）
            ,scan_date -- 影像扫描日期
            ,prec_brch -- 预约网点
            ,promt_prio -- 提升优先级
            ,blip_model -- 影像模型
            ,temp_acct_valid_dt -- 临时户有效日期
            ,vouch_group -- 业务场景凭证组合
            ,lp_cert_due_dt -- 法人到期日
            ,order_id -- 订单编号
            ,init_tm -- 发起时间
            ,acct_purp -- 账户用途 用于表示账户开立的账户用途
            ,acct_type -- 账户种类 00-无特殊用途 11-预算单位专用 12-非预算单位专用
            ,cert_type -- 证件类型
            ,check_sell_can -- 支票出售许可
            ,dpstr_name -- 存款人名称
            ,dps_type -- 储种 A01:单位活期,A05:财政存款,A06:临时存款,A09:活期同业存款
            ,fx_acct_rpt -- 外汇账户报送
            ,indu_class_encd -- 行业分类编码
            ,limit_ref -- 限额编码
            ,local_tax_reg_cert_num -- 地税登记证号
            ,main_acct -- 主账号
            ,major_category -- 存款人类别
            ,max_lmt -- 最大限额
            ,mobile_no -- 电话号码
            ,nation_tax_reg_cert_num -- 国税登记证号
            ,new_fx_proj -- 新外汇项目
            ,nra_flag -- NRA标识 0-否  1-是
            ,reg_loc -- 注册地址
            ,sec_doc_due_day -- 第二证件到期日
            ,sec_doc_num -- 第二证件号码
            ,sec_doc_typ -- 第二证件类型
            ,stl_cd -- 核算代码
            ,super_document_id -- 上级法人或单位负责人证件号码
            ,super_document_type -- 上级法人或单位负责人证件种类
            ,super_lp_or_dirt_corp_name -- 上级法人或主管单位名称
            ,super_name -- 上级法人或单位负责人姓名
            ,wthr_lmt -- 是否限额 0-否，1-是
            ,wthr_shar_seal -- 是否共用印鉴 0-否，1-是
            ,zipcode -- 邮政编码
            ,zone_cd -- 地区代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_pre_corporate_tb_op(
            id -- 唯一主键
            ,task_id -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
            ,glob_seq_num -- 全局流水号（取ESC）
            ,organ_no -- 交易机构号（取ESC）
            ,pretrial_status -- 预审状态（0-预审已受理，1-预审通过，2-预审不通过，3-已超期，4-已作废，5-审批中，6-已结束）
            ,pre_acpt_id -- 预受理编号
            ,pre_date -- 受理日期
            ,chn_encd -- 304002微信，301003企业网银  (渠道)
            ,papers_type -- 证件类型
            ,papers_number -- 证件号码
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,acct_prop -- 账户性质
            ,acct_name -- 账户名称
            ,acct_no -- 账号
            ,appoint_num -- 预受理次数
            ,prec_typ -- 预约类型(0-我要预约 1-我在现场)
            ,prec_biz -- 预约业务
            ,reserv_begin_time -- 预约开始时间
            ,reserv_end_time -- 预约结束时间
            ,pre_business_name -- 预受理业务名称（对公预受理）
            ,blip_id -- 影像批次号
            ,pre_branch_code -- 受理机构
            ,acct_seq_no -- 开户流水号
            ,copr_name -- 工作单位名称
            ,per_scope -- 经营范围
            ,cert_valid_dt -- 证件生效日期
            ,org_crdt_cd_cert_num -- 证明文件编号
            ,prod_loc -- 注册地址
            ,enro_cap -- 注册资本
            ,fr_name -- 法人姓名
            ,fr_cert_typ -- 法人证件号码
            ,fr_cert_due_dt -- 有效期
            ,contact_name -- 联系人名称
            ,cust_phone -- 电话号码
            ,blacklist_result -- 黑名单查证结果
            ,bank_code_result -- 银码查证结果
            ,remark -- 备注
            ,pre_time -- 受理时间
            ,pre_acpt_status -- 预受理状态(0 进行中 1 已完成 )
            ,state -- 业务状态（1.处理中 2.记账完成 3.记账失败 4.业务终止 5.已冲正 ）
            ,scan_date -- 影像扫描日期
            ,prec_brch -- 预约网点
            ,promt_prio -- 提升优先级
            ,blip_model -- 影像模型
            ,temp_acct_valid_dt -- 临时户有效日期
            ,vouch_group -- 业务场景凭证组合
            ,lp_cert_due_dt -- 法人到期日
            ,order_id -- 订单编号
            ,init_tm -- 发起时间
            ,acct_purp -- 账户用途 用于表示账户开立的账户用途
            ,acct_type -- 账户种类 00-无特殊用途 11-预算单位专用 12-非预算单位专用
            ,cert_type -- 证件类型
            ,check_sell_can -- 支票出售许可
            ,dpstr_name -- 存款人名称
            ,dps_type -- 储种 A01:单位活期,A05:财政存款,A06:临时存款,A09:活期同业存款
            ,fx_acct_rpt -- 外汇账户报送
            ,indu_class_encd -- 行业分类编码
            ,limit_ref -- 限额编码
            ,local_tax_reg_cert_num -- 地税登记证号
            ,main_acct -- 主账号
            ,major_category -- 存款人类别
            ,max_lmt -- 最大限额
            ,mobile_no -- 电话号码
            ,nation_tax_reg_cert_num -- 国税登记证号
            ,new_fx_proj -- 新外汇项目
            ,nra_flag -- NRA标识 0-否  1-是
            ,reg_loc -- 注册地址
            ,sec_doc_due_day -- 第二证件到期日
            ,sec_doc_num -- 第二证件号码
            ,sec_doc_typ -- 第二证件类型
            ,stl_cd -- 核算代码
            ,super_document_id -- 上级法人或单位负责人证件号码
            ,super_document_type -- 上级法人或单位负责人证件种类
            ,super_lp_or_dirt_corp_name -- 上级法人或主管单位名称
            ,super_name -- 上级法人或单位负责人姓名
            ,wthr_lmt -- 是否限额 0-否，1-是
            ,wthr_shar_seal -- 是否共用印鉴 0-否，1-是
            ,zipcode -- 邮政编码
            ,zone_cd -- 地区代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 唯一主键
    ,nvl(n.task_id, o.task_id) as task_id -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
    ,nvl(n.glob_seq_num, o.glob_seq_num) as glob_seq_num -- 全局流水号（取ESC）
    ,nvl(n.organ_no, o.organ_no) as organ_no -- 交易机构号（取ESC）
    ,nvl(n.pretrial_status, o.pretrial_status) as pretrial_status -- 预审状态（0-预审已受理，1-预审通过，2-预审不通过，3-已超期，4-已作废，5-审批中，6-已结束）
    ,nvl(n.pre_acpt_id, o.pre_acpt_id) as pre_acpt_id -- 预受理编号
    ,nvl(n.pre_date, o.pre_date) as pre_date -- 受理日期
    ,nvl(n.chn_encd, o.chn_encd) as chn_encd -- 304002微信，301003企业网银  (渠道)
    ,nvl(n.papers_type, o.papers_type) as papers_type -- 证件类型
    ,nvl(n.papers_number, o.papers_number) as papers_number -- 证件号码
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.acct_prop, o.acct_prop) as acct_prop -- 账户性质
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.acct_no, o.acct_no) as acct_no -- 账号
    ,nvl(n.appoint_num, o.appoint_num) as appoint_num -- 预受理次数
    ,nvl(n.prec_typ, o.prec_typ) as prec_typ -- 预约类型(0-我要预约 1-我在现场)
    ,nvl(n.prec_biz, o.prec_biz) as prec_biz -- 预约业务
    ,nvl(n.reserv_begin_time, o.reserv_begin_time) as reserv_begin_time -- 预约开始时间
    ,nvl(n.reserv_end_time, o.reserv_end_time) as reserv_end_time -- 预约结束时间
    ,nvl(n.pre_business_name, o.pre_business_name) as pre_business_name -- 预受理业务名称（对公预受理）
    ,nvl(n.blip_id, o.blip_id) as blip_id -- 影像批次号
    ,nvl(n.pre_branch_code, o.pre_branch_code) as pre_branch_code -- 受理机构
    ,nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 开户流水号
    ,nvl(n.copr_name, o.copr_name) as copr_name -- 工作单位名称
    ,nvl(n.per_scope, o.per_scope) as per_scope -- 经营范围
    ,nvl(n.cert_valid_dt, o.cert_valid_dt) as cert_valid_dt -- 证件生效日期
    ,nvl(n.org_crdt_cd_cert_num, o.org_crdt_cd_cert_num) as org_crdt_cd_cert_num -- 证明文件编号
    ,nvl(n.prod_loc, o.prod_loc) as prod_loc -- 注册地址
    ,nvl(n.enro_cap, o.enro_cap) as enro_cap -- 注册资本
    ,nvl(n.fr_name, o.fr_name) as fr_name -- 法人姓名
    ,nvl(n.fr_cert_typ, o.fr_cert_typ) as fr_cert_typ -- 法人证件号码
    ,nvl(n.fr_cert_due_dt, o.fr_cert_due_dt) as fr_cert_due_dt -- 有效期
    ,nvl(n.contact_name, o.contact_name) as contact_name -- 联系人名称
    ,nvl(n.cust_phone, o.cust_phone) as cust_phone -- 电话号码
    ,nvl(n.blacklist_result, o.blacklist_result) as blacklist_result -- 黑名单查证结果
    ,nvl(n.bank_code_result, o.bank_code_result) as bank_code_result -- 银码查证结果
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.pre_time, o.pre_time) as pre_time -- 受理时间
    ,nvl(n.pre_acpt_status, o.pre_acpt_status) as pre_acpt_status -- 预受理状态(0 进行中 1 已完成 )
    ,nvl(n.state, o.state) as state -- 业务状态（1.处理中 2.记账完成 3.记账失败 4.业务终止 5.已冲正 ）
    ,nvl(n.scan_date, o.scan_date) as scan_date -- 影像扫描日期
    ,nvl(n.prec_brch, o.prec_brch) as prec_brch -- 预约网点
    ,nvl(n.promt_prio, o.promt_prio) as promt_prio -- 提升优先级
    ,nvl(n.blip_model, o.blip_model) as blip_model -- 影像模型
    ,nvl(n.temp_acct_valid_dt, o.temp_acct_valid_dt) as temp_acct_valid_dt -- 临时户有效日期
    ,nvl(n.vouch_group, o.vouch_group) as vouch_group -- 业务场景凭证组合
    ,nvl(n.lp_cert_due_dt, o.lp_cert_due_dt) as lp_cert_due_dt -- 法人到期日
    ,nvl(n.order_id, o.order_id) as order_id -- 订单编号
    ,nvl(n.init_tm, o.init_tm) as init_tm -- 发起时间
    ,nvl(n.acct_purp, o.acct_purp) as acct_purp -- 账户用途 用于表示账户开立的账户用途
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户种类 00-无特殊用途 11-预算单位专用 12-非预算单位专用
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型
    ,nvl(n.check_sell_can, o.check_sell_can) as check_sell_can -- 支票出售许可
    ,nvl(n.dpstr_name, o.dpstr_name) as dpstr_name -- 存款人名称
    ,nvl(n.dps_type, o.dps_type) as dps_type -- 储种 A01:单位活期,A05:财政存款,A06:临时存款,A09:活期同业存款
    ,nvl(n.fx_acct_rpt, o.fx_acct_rpt) as fx_acct_rpt -- 外汇账户报送
    ,nvl(n.indu_class_encd, o.indu_class_encd) as indu_class_encd -- 行业分类编码
    ,nvl(n.limit_ref, o.limit_ref) as limit_ref -- 限额编码
    ,nvl(n.local_tax_reg_cert_num, o.local_tax_reg_cert_num) as local_tax_reg_cert_num -- 地税登记证号
    ,nvl(n.main_acct, o.main_acct) as main_acct -- 主账号
    ,nvl(n.major_category, o.major_category) as major_category -- 存款人类别
    ,nvl(n.max_lmt, o.max_lmt) as max_lmt -- 最大限额
    ,nvl(n.mobile_no, o.mobile_no) as mobile_no -- 电话号码
    ,nvl(n.nation_tax_reg_cert_num, o.nation_tax_reg_cert_num) as nation_tax_reg_cert_num -- 国税登记证号
    ,nvl(n.new_fx_proj, o.new_fx_proj) as new_fx_proj -- 新外汇项目
    ,nvl(n.nra_flag, o.nra_flag) as nra_flag -- NRA标识 0-否  1-是
    ,nvl(n.reg_loc, o.reg_loc) as reg_loc -- 注册地址
    ,nvl(n.sec_doc_due_day, o.sec_doc_due_day) as sec_doc_due_day -- 第二证件到期日
    ,nvl(n.sec_doc_num, o.sec_doc_num) as sec_doc_num -- 第二证件号码
    ,nvl(n.sec_doc_typ, o.sec_doc_typ) as sec_doc_typ -- 第二证件类型
    ,nvl(n.stl_cd, o.stl_cd) as stl_cd -- 核算代码
    ,nvl(n.super_document_id, o.super_document_id) as super_document_id -- 上级法人或单位负责人证件号码
    ,nvl(n.super_document_type, o.super_document_type) as super_document_type -- 上级法人或单位负责人证件种类
    ,nvl(n.super_lp_or_dirt_corp_name, o.super_lp_or_dirt_corp_name) as super_lp_or_dirt_corp_name -- 上级法人或主管单位名称
    ,nvl(n.super_name, o.super_name) as super_name -- 上级法人或单位负责人姓名
    ,nvl(n.wthr_lmt, o.wthr_lmt) as wthr_lmt -- 是否限额 0-否，1-是
    ,nvl(n.wthr_shar_seal, o.wthr_shar_seal) as wthr_shar_seal -- 是否共用印鉴 0-否，1-是
    ,nvl(n.zipcode, o.zipcode) as zipcode -- 邮政编码
    ,nvl(n.zone_cd, o.zone_cd) as zone_cd -- 地区代码
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_bp_pre_corporate_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_bp_pre_corporate_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.task_id <> n.task_id
        or o.glob_seq_num <> n.glob_seq_num
        or o.organ_no <> n.organ_no
        or o.pretrial_status <> n.pretrial_status
        or o.pre_acpt_id <> n.pre_acpt_id
        or o.pre_date <> n.pre_date
        or o.chn_encd <> n.chn_encd
        or o.papers_type <> n.papers_type
        or o.papers_number <> n.papers_number
        or o.cust_no <> n.cust_no
        or o.cust_name <> n.cust_name
        or o.acct_prop <> n.acct_prop
        or o.acct_name <> n.acct_name
        or o.acct_no <> n.acct_no
        or o.appoint_num <> n.appoint_num
        or o.prec_typ <> n.prec_typ
        or o.prec_biz <> n.prec_biz
        or o.reserv_begin_time <> n.reserv_begin_time
        or o.reserv_end_time <> n.reserv_end_time
        or o.pre_business_name <> n.pre_business_name
        or o.blip_id <> n.blip_id
        or o.pre_branch_code <> n.pre_branch_code
        or o.acct_seq_no <> n.acct_seq_no
        or o.copr_name <> n.copr_name
        or o.per_scope <> n.per_scope
        or o.cert_valid_dt <> n.cert_valid_dt
        or o.org_crdt_cd_cert_num <> n.org_crdt_cd_cert_num
        or o.prod_loc <> n.prod_loc
        or o.enro_cap <> n.enro_cap
        or o.fr_name <> n.fr_name
        or o.fr_cert_typ <> n.fr_cert_typ
        or o.fr_cert_due_dt <> n.fr_cert_due_dt
        or o.contact_name <> n.contact_name
        or o.cust_phone <> n.cust_phone
        or o.blacklist_result <> n.blacklist_result
        or o.bank_code_result <> n.bank_code_result
        or o.remark <> n.remark
        or o.pre_time <> n.pre_time
        or o.pre_acpt_status <> n.pre_acpt_status
        or o.state <> n.state
        or o.scan_date <> n.scan_date
        or o.prec_brch <> n.prec_brch
        or o.promt_prio <> n.promt_prio
        or o.blip_model <> n.blip_model
        or o.temp_acct_valid_dt <> n.temp_acct_valid_dt
        or o.vouch_group <> n.vouch_group
        or o.lp_cert_due_dt <> n.lp_cert_due_dt
        or o.order_id <> n.order_id
        or o.init_tm <> n.init_tm
        or o.acct_purp <> n.acct_purp
        or o.acct_type <> n.acct_type
        or o.cert_type <> n.cert_type
        or o.check_sell_can <> n.check_sell_can
        or o.dpstr_name <> n.dpstr_name
        or o.dps_type <> n.dps_type
        or o.fx_acct_rpt <> n.fx_acct_rpt
        or o.indu_class_encd <> n.indu_class_encd
        or o.limit_ref <> n.limit_ref
        or o.local_tax_reg_cert_num <> n.local_tax_reg_cert_num
        or o.main_acct <> n.main_acct
        or o.major_category <> n.major_category
        or o.max_lmt <> n.max_lmt
        or o.mobile_no <> n.mobile_no
        or o.nation_tax_reg_cert_num <> n.nation_tax_reg_cert_num
        or o.new_fx_proj <> n.new_fx_proj
        or o.nra_flag <> n.nra_flag
        or o.reg_loc <> n.reg_loc
        or o.sec_doc_due_day <> n.sec_doc_due_day
        or o.sec_doc_num <> n.sec_doc_num
        or o.sec_doc_typ <> n.sec_doc_typ
        or o.stl_cd <> n.stl_cd
        or o.super_document_id <> n.super_document_id
        or o.super_document_type <> n.super_document_type
        or o.super_lp_or_dirt_corp_name <> n.super_lp_or_dirt_corp_name
        or o.super_name <> n.super_name
        or o.wthr_lmt <> n.wthr_lmt
        or o.wthr_shar_seal <> n.wthr_shar_seal
        or o.zipcode <> n.zipcode
        or o.zone_cd <> n.zone_cd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_bp_pre_corporate_tb_cl(
            id -- 唯一主键
            ,task_id -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
            ,glob_seq_num -- 全局流水号（取ESC）
            ,organ_no -- 交易机构号（取ESC）
            ,pretrial_status -- 预审状态（0-预审已受理，1-预审通过，2-预审不通过，3-已超期，4-已作废，5-审批中，6-已结束）
            ,pre_acpt_id -- 预受理编号
            ,pre_date -- 受理日期
            ,chn_encd -- 304002微信，301003企业网银  (渠道)
            ,papers_type -- 证件类型
            ,papers_number -- 证件号码
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,acct_prop -- 账户性质
            ,acct_name -- 账户名称
            ,acct_no -- 账号
            ,appoint_num -- 预受理次数
            ,prec_typ -- 预约类型(0-我要预约 1-我在现场)
            ,prec_biz -- 预约业务
            ,reserv_begin_time -- 预约开始时间
            ,reserv_end_time -- 预约结束时间
            ,pre_business_name -- 预受理业务名称（对公预受理）
            ,blip_id -- 影像批次号
            ,pre_branch_code -- 受理机构
            ,acct_seq_no -- 开户流水号
            ,copr_name -- 工作单位名称
            ,per_scope -- 经营范围
            ,cert_valid_dt -- 证件生效日期
            ,org_crdt_cd_cert_num -- 证明文件编号
            ,prod_loc -- 注册地址
            ,enro_cap -- 注册资本
            ,fr_name -- 法人姓名
            ,fr_cert_typ -- 法人证件号码
            ,fr_cert_due_dt -- 有效期
            ,contact_name -- 联系人名称
            ,cust_phone -- 电话号码
            ,blacklist_result -- 黑名单查证结果
            ,bank_code_result -- 银码查证结果
            ,remark -- 备注
            ,pre_time -- 受理时间
            ,pre_acpt_status -- 预受理状态(0 进行中 1 已完成 )
            ,state -- 业务状态（1.处理中 2.记账完成 3.记账失败 4.业务终止 5.已冲正 ）
            ,scan_date -- 影像扫描日期
            ,prec_brch -- 预约网点
            ,promt_prio -- 提升优先级
            ,blip_model -- 影像模型
            ,temp_acct_valid_dt -- 临时户有效日期
            ,vouch_group -- 业务场景凭证组合
            ,lp_cert_due_dt -- 法人到期日
            ,order_id -- 订单编号
            ,init_tm -- 发起时间
            ,acct_purp -- 账户用途 用于表示账户开立的账户用途
            ,acct_type -- 账户种类 00-无特殊用途 11-预算单位专用 12-非预算单位专用
            ,cert_type -- 证件类型
            ,check_sell_can -- 支票出售许可
            ,dpstr_name -- 存款人名称
            ,dps_type -- 储种 A01:单位活期,A05:财政存款,A06:临时存款,A09:活期同业存款
            ,fx_acct_rpt -- 外汇账户报送
            ,indu_class_encd -- 行业分类编码
            ,limit_ref -- 限额编码
            ,local_tax_reg_cert_num -- 地税登记证号
            ,main_acct -- 主账号
            ,major_category -- 存款人类别
            ,max_lmt -- 最大限额
            ,mobile_no -- 电话号码
            ,nation_tax_reg_cert_num -- 国税登记证号
            ,new_fx_proj -- 新外汇项目
            ,nra_flag -- NRA标识 0-否  1-是
            ,reg_loc -- 注册地址
            ,sec_doc_due_day -- 第二证件到期日
            ,sec_doc_num -- 第二证件号码
            ,sec_doc_typ -- 第二证件类型
            ,stl_cd -- 核算代码
            ,super_document_id -- 上级法人或单位负责人证件号码
            ,super_document_type -- 上级法人或单位负责人证件种类
            ,super_lp_or_dirt_corp_name -- 上级法人或主管单位名称
            ,super_name -- 上级法人或单位负责人姓名
            ,wthr_lmt -- 是否限额 0-否，1-是
            ,wthr_shar_seal -- 是否共用印鉴 0-否，1-是
            ,zipcode -- 邮政编码
            ,zone_cd -- 地区代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_bp_pre_corporate_tb_op(
            id -- 唯一主键
            ,task_id -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
            ,glob_seq_num -- 全局流水号（取ESC）
            ,organ_no -- 交易机构号（取ESC）
            ,pretrial_status -- 预审状态（0-预审已受理，1-预审通过，2-预审不通过，3-已超期，4-已作废，5-审批中，6-已结束）
            ,pre_acpt_id -- 预受理编号
            ,pre_date -- 受理日期
            ,chn_encd -- 304002微信，301003企业网银  (渠道)
            ,papers_type -- 证件类型
            ,papers_number -- 证件号码
            ,cust_no -- 客户编号
            ,cust_name -- 客户名称
            ,acct_prop -- 账户性质
            ,acct_name -- 账户名称
            ,acct_no -- 账号
            ,appoint_num -- 预受理次数
            ,prec_typ -- 预约类型(0-我要预约 1-我在现场)
            ,prec_biz -- 预约业务
            ,reserv_begin_time -- 预约开始时间
            ,reserv_end_time -- 预约结束时间
            ,pre_business_name -- 预受理业务名称（对公预受理）
            ,blip_id -- 影像批次号
            ,pre_branch_code -- 受理机构
            ,acct_seq_no -- 开户流水号
            ,copr_name -- 工作单位名称
            ,per_scope -- 经营范围
            ,cert_valid_dt -- 证件生效日期
            ,org_crdt_cd_cert_num -- 证明文件编号
            ,prod_loc -- 注册地址
            ,enro_cap -- 注册资本
            ,fr_name -- 法人姓名
            ,fr_cert_typ -- 法人证件号码
            ,fr_cert_due_dt -- 有效期
            ,contact_name -- 联系人名称
            ,cust_phone -- 电话号码
            ,blacklist_result -- 黑名单查证结果
            ,bank_code_result -- 银码查证结果
            ,remark -- 备注
            ,pre_time -- 受理时间
            ,pre_acpt_status -- 预受理状态(0 进行中 1 已完成 )
            ,state -- 业务状态（1.处理中 2.记账完成 3.记账失败 4.业务终止 5.已冲正 ）
            ,scan_date -- 影像扫描日期
            ,prec_brch -- 预约网点
            ,promt_prio -- 提升优先级
            ,blip_model -- 影像模型
            ,temp_acct_valid_dt -- 临时户有效日期
            ,vouch_group -- 业务场景凭证组合
            ,lp_cert_due_dt -- 法人到期日
            ,order_id -- 订单编号
            ,init_tm -- 发起时间
            ,acct_purp -- 账户用途 用于表示账户开立的账户用途
            ,acct_type -- 账户种类 00-无特殊用途 11-预算单位专用 12-非预算单位专用
            ,cert_type -- 证件类型
            ,check_sell_can -- 支票出售许可
            ,dpstr_name -- 存款人名称
            ,dps_type -- 储种 A01:单位活期,A05:财政存款,A06:临时存款,A09:活期同业存款
            ,fx_acct_rpt -- 外汇账户报送
            ,indu_class_encd -- 行业分类编码
            ,limit_ref -- 限额编码
            ,local_tax_reg_cert_num -- 地税登记证号
            ,main_acct -- 主账号
            ,major_category -- 存款人类别
            ,max_lmt -- 最大限额
            ,mobile_no -- 电话号码
            ,nation_tax_reg_cert_num -- 国税登记证号
            ,new_fx_proj -- 新外汇项目
            ,nra_flag -- NRA标识 0-否  1-是
            ,reg_loc -- 注册地址
            ,sec_doc_due_day -- 第二证件到期日
            ,sec_doc_num -- 第二证件号码
            ,sec_doc_typ -- 第二证件类型
            ,stl_cd -- 核算代码
            ,super_document_id -- 上级法人或单位负责人证件号码
            ,super_document_type -- 上级法人或单位负责人证件种类
            ,super_lp_or_dirt_corp_name -- 上级法人或主管单位名称
            ,super_name -- 上级法人或单位负责人姓名
            ,wthr_lmt -- 是否限额 0-否，1-是
            ,wthr_shar_seal -- 是否共用印鉴 0-否，1-是
            ,zipcode -- 邮政编码
            ,zone_cd -- 地区代码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 唯一主键
    ,o.task_id -- 任务号(集中作业取ESC订单号，远程授权放授权任务号)
    ,o.glob_seq_num -- 全局流水号（取ESC）
    ,o.organ_no -- 交易机构号（取ESC）
    ,o.pretrial_status -- 预审状态（0-预审已受理，1-预审通过，2-预审不通过，3-已超期，4-已作废，5-审批中，6-已结束）
    ,o.pre_acpt_id -- 预受理编号
    ,o.pre_date -- 受理日期
    ,o.chn_encd -- 304002微信，301003企业网银  (渠道)
    ,o.papers_type -- 证件类型
    ,o.papers_number -- 证件号码
    ,o.cust_no -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.acct_prop -- 账户性质
    ,o.acct_name -- 账户名称
    ,o.acct_no -- 账号
    ,o.appoint_num -- 预受理次数
    ,o.prec_typ -- 预约类型(0-我要预约 1-我在现场)
    ,o.prec_biz -- 预约业务
    ,o.reserv_begin_time -- 预约开始时间
    ,o.reserv_end_time -- 预约结束时间
    ,o.pre_business_name -- 预受理业务名称（对公预受理）
    ,o.blip_id -- 影像批次号
    ,o.pre_branch_code -- 受理机构
    ,o.acct_seq_no -- 开户流水号
    ,o.copr_name -- 工作单位名称
    ,o.per_scope -- 经营范围
    ,o.cert_valid_dt -- 证件生效日期
    ,o.org_crdt_cd_cert_num -- 证明文件编号
    ,o.prod_loc -- 注册地址
    ,o.enro_cap -- 注册资本
    ,o.fr_name -- 法人姓名
    ,o.fr_cert_typ -- 法人证件号码
    ,o.fr_cert_due_dt -- 有效期
    ,o.contact_name -- 联系人名称
    ,o.cust_phone -- 电话号码
    ,o.blacklist_result -- 黑名单查证结果
    ,o.bank_code_result -- 银码查证结果
    ,o.remark -- 备注
    ,o.pre_time -- 受理时间
    ,o.pre_acpt_status -- 预受理状态(0 进行中 1 已完成 )
    ,o.state -- 业务状态（1.处理中 2.记账完成 3.记账失败 4.业务终止 5.已冲正 ）
    ,o.scan_date -- 影像扫描日期
    ,o.prec_brch -- 预约网点
    ,o.promt_prio -- 提升优先级
    ,o.blip_model -- 影像模型
    ,o.temp_acct_valid_dt -- 临时户有效日期
    ,o.vouch_group -- 业务场景凭证组合
    ,o.lp_cert_due_dt -- 法人到期日
    ,o.order_id -- 订单编号
    ,o.init_tm -- 发起时间
    ,o.acct_purp -- 账户用途 用于表示账户开立的账户用途
    ,o.acct_type -- 账户种类 00-无特殊用途 11-预算单位专用 12-非预算单位专用
    ,o.cert_type -- 证件类型
    ,o.check_sell_can -- 支票出售许可
    ,o.dpstr_name -- 存款人名称
    ,o.dps_type -- 储种 A01:单位活期,A05:财政存款,A06:临时存款,A09:活期同业存款
    ,o.fx_acct_rpt -- 外汇账户报送
    ,o.indu_class_encd -- 行业分类编码
    ,o.limit_ref -- 限额编码
    ,o.local_tax_reg_cert_num -- 地税登记证号
    ,o.main_acct -- 主账号
    ,o.major_category -- 存款人类别
    ,o.max_lmt -- 最大限额
    ,o.mobile_no -- 电话号码
    ,o.nation_tax_reg_cert_num -- 国税登记证号
    ,o.new_fx_proj -- 新外汇项目
    ,o.nra_flag -- NRA标识 0-否  1-是
    ,o.reg_loc -- 注册地址
    ,o.sec_doc_due_day -- 第二证件到期日
    ,o.sec_doc_num -- 第二证件号码
    ,o.sec_doc_typ -- 第二证件类型
    ,o.stl_cd -- 核算代码
    ,o.super_document_id -- 上级法人或单位负责人证件号码
    ,o.super_document_type -- 上级法人或单位负责人证件种类
    ,o.super_lp_or_dirt_corp_name -- 上级法人或主管单位名称
    ,o.super_name -- 上级法人或单位负责人姓名
    ,o.wthr_lmt -- 是否限额 0-否，1-是
    ,o.wthr_shar_seal -- 是否共用印鉴 0-否，1-是
    ,o.zipcode -- 邮政编码
    ,o.zone_cd -- 地区代码
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.scps_bp_pre_corporate_tb_bk o
    left join ${iol_schema}.scps_bp_pre_corporate_tb_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_bp_pre_corporate_tb_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_bp_pre_corporate_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_bp_pre_corporate_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_bp_pre_corporate_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_bp_pre_corporate_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_bp_pre_corporate_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_bp_pre_corporate_tb_cl;
alter table ${iol_schema}.scps_bp_pre_corporate_tb exchange partition p_20991231 with table ${iol_schema}.scps_bp_pre_corporate_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_bp_pre_corporate_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_bp_pre_corporate_tb_op purge;
drop table ${iol_schema}.scps_bp_pre_corporate_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_bp_pre_corporate_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_bp_pre_corporate_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
