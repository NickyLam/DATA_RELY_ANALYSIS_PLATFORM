/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1usetpsignacctinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1usetpsignacctinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1usetpsignacctinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1usetpsignacctinfo(
    txn_dt varchar2(12) -- 交易日期
    ,txn_tms varchar2(45) -- 交易时间
    ,txn_cd varchar2(30) -- 中台交易码
    ,trx_seq varchar2(60) -- 交易流水号
    ,app_dt varchar2(12) -- 操作日期
    ,app_tm varchar2(45) -- 操作日期
    ,app_id varchar2(60) -- 申请编号
    ,app_ord_nbr varchar2(30) -- 申请序号
    ,merch_status varchar2(2) -- 商户状态：0:未启用、1:已启用、2:已停用
    ,aprv_status varchar2(2) -- 审批状态:0:待提交、1:待审批、2:已通过、3:未通过
    ,txn_typ varchar2(15) -- 操作类型：0:商户注册、1:信息变更、2:服务变更
    ,merch_id varchar2(30) -- 商户编号
    ,merch_name varchar2(300) -- 商户名称
    ,regu_mode varchar2(15) -- 监管模式：01银行存管模式、02风险储备金模式、03复合模式；
    ,acct_typ varchar2(6) -- 账户类型 01:监管账户 02:保证金账户
    ,regu_acct_num varchar2(75) -- 监管账号信息-账号
    ,regu_act_nm varchar2(150) -- 监管账号信息-户名
    ,regu_open_bk_name varchar2(300) -- 监管账号信息-开户行名称
    ,regu_open_bk_num varchar2(30) -- 监管账号信息-开户行行号
    ,acct_typ_cd varchar2(6) -- 账户类型 01:监管账户 02:保证金账户
    ,marg_acct_num varchar2(75) -- 保证金账号信息-账号
    ,marg_act_nm varchar2(300) -- 保证金账号信息-户名
    ,marg_open_bk_name varchar2(300) -- 保证金账号信息-开户行名称
    ,marg_open_bk_num varchar2(30) -- 保证金账号信息-开户行行号
    ,corp_name varchar2(300) -- 基本信息-公司名称
    ,csld_soci_crdt_cd varchar2(30) -- 基本信息-统一社会信用代码
    ,corp_login_addr varchar2(300) -- 基本信息-注册地址
    ,clog_addr varchar2(300) -- 基本信息-办学地址
    ,corp_estab_dt varchar2(12) -- 基本信息-成立日期
    ,corp_tel_num varchar2(20) -- 基本信息-办公电话
    ,oper_scope varchar2(4000) -- 基本信息-经营范围
    ,oper_licence_url varchar2(750) -- 基本信息-营业执照url地址
    ,qlfy_proof_url varchar2(750) -- 基本信息-资质证明url地址
    ,blng_bran_num varchar2(30) -- 管理职责-归属分行行号
    ,blng_bran_name varchar2(300) -- 管理职责-归属分行名称
    ,lp_name varchar2(300) -- 法人代表信息-姓名
    ,lp_cert_typ varchar2(6) -- 法人代表信息-证件类型
    ,lp_iden_num varchar2(60) -- 法人代表信息-身份证号码
    ,lp_ceph_num varchar2(20) -- 法人代表信息-手机号码
    ,lp_iden_fro_url varchar2(600) -- 法人身份证正面url地址
    ,lp_iden_obv_url varchar2(600) -- 法人身份证反面url地址
    ,oprt_name varchar2(150) -- 经办人信息-姓名
    ,oprt_ceph_num varchar2(20) -- 经办人信息-手机号码
    ,oprt_cert_typ varchar2(6) -- 经办人信息-证件类型
    ,oprt_cert_num varchar2(60) -- 经办人信息-证件号码
    ,oprt_cert_url varchar2(750) -- 经办人链接地址
    ,oprt_cert_print_piece_url varchar2(750) -- 经办人打印链接地址
    ,aprv_comnt varchar2(300) -- 审批人意见
    ,input_tell_num varchar2(30) -- 录入柜员号
    ,input_org_id varchar2(30) -- 录入机构号
    ,check_tell_num varchar2(30) -- 复核柜员号
    ,check_org_id varchar2(30) -- 复核机构号
    ,apprv_tell_num varchar2(30) -- 审批柜员号
    ,apprv_org_id varchar2(30) -- 审批机构号
    ,memo varchar2(600) -- 审批备注
    ,bak1 varchar2(150) -- 备注字段1
    ,bak2 varchar2(150) -- 备注字段2
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
grant select on ${iol_schema}.mpcs_a1usetpsignacctinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1usetpsignacctinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1usetpsignacctinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1usetpsignacctinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1usetpsignacctinfo is '商户签约信息表';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.txn_dt is '交易日期';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.txn_tms is '交易时间';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.txn_cd is '中台交易码';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.trx_seq is '交易流水号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.app_dt is '操作日期';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.app_tm is '操作日期';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.app_id is '申请编号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.app_ord_nbr is '申请序号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.merch_status is '商户状态：0:未启用、1:已启用、2:已停用';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.aprv_status is '审批状态:0:待提交、1:待审批、2:已通过、3:未通过';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.txn_typ is '操作类型：0:商户注册、1:信息变更、2:服务变更';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.merch_id is '商户编号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.merch_name is '商户名称';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.regu_mode is '监管模式：01银行存管模式、02风险储备金模式、03复合模式；';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.acct_typ is '账户类型 01:监管账户 02:保证金账户';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.regu_acct_num is '监管账号信息-账号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.regu_act_nm is '监管账号信息-户名';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.regu_open_bk_name is '监管账号信息-开户行名称';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.regu_open_bk_num is '监管账号信息-开户行行号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.acct_typ_cd is '账户类型 01:监管账户 02:保证金账户';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.marg_acct_num is '保证金账号信息-账号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.marg_act_nm is '保证金账号信息-户名';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.marg_open_bk_name is '保证金账号信息-开户行名称';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.marg_open_bk_num is '保证金账号信息-开户行行号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.corp_name is '基本信息-公司名称';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.csld_soci_crdt_cd is '基本信息-统一社会信用代码';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.corp_login_addr is '基本信息-注册地址';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.clog_addr is '基本信息-办学地址';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.corp_estab_dt is '基本信息-成立日期';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.corp_tel_num is '基本信息-办公电话';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.oper_scope is '基本信息-经营范围';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.oper_licence_url is '基本信息-营业执照url地址';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.qlfy_proof_url is '基本信息-资质证明url地址';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.blng_bran_num is '管理职责-归属分行行号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.blng_bran_name is '管理职责-归属分行名称';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.lp_name is '法人代表信息-姓名';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.lp_cert_typ is '法人代表信息-证件类型';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.lp_iden_num is '法人代表信息-身份证号码';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.lp_ceph_num is '法人代表信息-手机号码';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.lp_iden_fro_url is '法人身份证正面url地址';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.lp_iden_obv_url is '法人身份证反面url地址';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.oprt_name is '经办人信息-姓名';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.oprt_ceph_num is '经办人信息-手机号码';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.oprt_cert_typ is '经办人信息-证件类型';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.oprt_cert_num is '经办人信息-证件号码';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.oprt_cert_url is '经办人链接地址';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.oprt_cert_print_piece_url is '经办人打印链接地址';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.aprv_comnt is '审批人意见';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.input_tell_num is '录入柜员号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.input_org_id is '录入机构号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.check_tell_num is '复核柜员号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.check_org_id is '复核机构号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.apprv_tell_num is '审批柜员号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.apprv_org_id is '审批机构号';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.memo is '审批备注';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.bak1 is '备注字段1';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.bak2 is '备注字段2';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1usetpsignacctinfo.etl_timestamp is 'ETL处理时间戳';
