/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a1usetpsignacctinfo
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
create table ${iol_schema}.mpcs_a1usetpsignacctinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a1usetpsignacctinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1usetpsignacctinfo_op purge;
drop table ${iol_schema}.mpcs_a1usetpsignacctinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1usetpsignacctinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1usetpsignacctinfo where 0=1;

create table ${iol_schema}.mpcs_a1usetpsignacctinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a1usetpsignacctinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1usetpsignacctinfo_cl(
            txn_dt -- 交易日期
            ,txn_tms -- 交易时间
            ,txn_cd -- 中台交易码
            ,trx_seq -- 交易流水号
            ,app_dt -- 操作日期
            ,app_tm -- 操作日期
            ,app_id -- 申请编号
            ,app_ord_nbr -- 申请序号
            ,merch_status -- 商户状态：0:未启用、1:已启用、2:已停用
            ,aprv_status -- 审批状态:0:待提交、1:待审批、2:已通过、3:未通过
            ,txn_typ -- 操作类型：0:商户注册、1:信息变更、2:服务变更
            ,merch_id -- 商户编号
            ,merch_name -- 商户名称
            ,regu_mode -- 监管模式：01银行存管模式、02风险储备金模式、03复合模式；
            ,acct_typ -- 账户类型 01:监管账户 02:保证金账户
            ,regu_acct_num -- 监管账号信息-账号
            ,regu_act_nm -- 监管账号信息-户名
            ,regu_open_bk_name -- 监管账号信息-开户行名称
            ,regu_open_bk_num -- 监管账号信息-开户行行号
            ,acct_typ_cd -- 账户类型 01:监管账户 02:保证金账户
            ,marg_acct_num -- 保证金账号信息-账号
            ,marg_act_nm -- 保证金账号信息-户名
            ,marg_open_bk_name -- 保证金账号信息-开户行名称
            ,marg_open_bk_num -- 保证金账号信息-开户行行号
            ,corp_name -- 基本信息-公司名称
            ,csld_soci_crdt_cd -- 基本信息-统一社会信用代码
            ,corp_login_addr -- 基本信息-注册地址
            ,clog_addr -- 基本信息-办学地址
            ,corp_estab_dt -- 基本信息-成立日期
            ,corp_tel_num -- 基本信息-办公电话
            ,oper_scope -- 基本信息-经营范围
            ,oper_licence_url -- 基本信息-营业执照URL地址
            ,qlfy_proof_url -- 基本信息-资质证明URL地址
            ,blng_bran_num -- 管理职责-归属分行行号
            ,blng_bran_name -- 管理职责-归属分行名称
            ,lp_name -- 法人代表信息-姓名
            ,lp_cert_typ -- 法人代表信息-证件类型
            ,lp_iden_num -- 法人代表信息-身份证号码
            ,lp_ceph_num -- 法人代表信息-手机号码
            ,lp_iden_fro_url -- 法人身份证正面URL地址
            ,lp_iden_obv_url -- 法人身份证反面URL地址
            ,oprt_name -- 经办人信息-姓名
            ,oprt_ceph_num -- 经办人信息-手机号码
            ,oprt_cert_typ -- 经办人信息-证件类型
            ,oprt_cert_num -- 经办人信息-证件号码
            ,oprt_cert_url -- 经办人链接地址
            ,oprt_cert_print_piece_url -- 经办人打印链接地址
            ,aprv_comnt -- 审批人意见
            ,input_tell_num -- 录入柜员号
            ,input_org_id -- 录入机构号
            ,check_tell_num -- 复核柜员号
            ,check_org_id -- 复核机构号
            ,apprv_tell_num -- 审批柜员号
            ,apprv_org_id -- 审批机构号
            ,memo -- 审批备注
            ,bak1 -- 备注字段1
            ,bak2 -- 备注字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1usetpsignacctinfo_op(
            txn_dt -- 交易日期
            ,txn_tms -- 交易时间
            ,txn_cd -- 中台交易码
            ,trx_seq -- 交易流水号
            ,app_dt -- 操作日期
            ,app_tm -- 操作日期
            ,app_id -- 申请编号
            ,app_ord_nbr -- 申请序号
            ,merch_status -- 商户状态：0:未启用、1:已启用、2:已停用
            ,aprv_status -- 审批状态:0:待提交、1:待审批、2:已通过、3:未通过
            ,txn_typ -- 操作类型：0:商户注册、1:信息变更、2:服务变更
            ,merch_id -- 商户编号
            ,merch_name -- 商户名称
            ,regu_mode -- 监管模式：01银行存管模式、02风险储备金模式、03复合模式；
            ,acct_typ -- 账户类型 01:监管账户 02:保证金账户
            ,regu_acct_num -- 监管账号信息-账号
            ,regu_act_nm -- 监管账号信息-户名
            ,regu_open_bk_name -- 监管账号信息-开户行名称
            ,regu_open_bk_num -- 监管账号信息-开户行行号
            ,acct_typ_cd -- 账户类型 01:监管账户 02:保证金账户
            ,marg_acct_num -- 保证金账号信息-账号
            ,marg_act_nm -- 保证金账号信息-户名
            ,marg_open_bk_name -- 保证金账号信息-开户行名称
            ,marg_open_bk_num -- 保证金账号信息-开户行行号
            ,corp_name -- 基本信息-公司名称
            ,csld_soci_crdt_cd -- 基本信息-统一社会信用代码
            ,corp_login_addr -- 基本信息-注册地址
            ,clog_addr -- 基本信息-办学地址
            ,corp_estab_dt -- 基本信息-成立日期
            ,corp_tel_num -- 基本信息-办公电话
            ,oper_scope -- 基本信息-经营范围
            ,oper_licence_url -- 基本信息-营业执照URL地址
            ,qlfy_proof_url -- 基本信息-资质证明URL地址
            ,blng_bran_num -- 管理职责-归属分行行号
            ,blng_bran_name -- 管理职责-归属分行名称
            ,lp_name -- 法人代表信息-姓名
            ,lp_cert_typ -- 法人代表信息-证件类型
            ,lp_iden_num -- 法人代表信息-身份证号码
            ,lp_ceph_num -- 法人代表信息-手机号码
            ,lp_iden_fro_url -- 法人身份证正面URL地址
            ,lp_iden_obv_url -- 法人身份证反面URL地址
            ,oprt_name -- 经办人信息-姓名
            ,oprt_ceph_num -- 经办人信息-手机号码
            ,oprt_cert_typ -- 经办人信息-证件类型
            ,oprt_cert_num -- 经办人信息-证件号码
            ,oprt_cert_url -- 经办人链接地址
            ,oprt_cert_print_piece_url -- 经办人打印链接地址
            ,aprv_comnt -- 审批人意见
            ,input_tell_num -- 录入柜员号
            ,input_org_id -- 录入机构号
            ,check_tell_num -- 复核柜员号
            ,check_org_id -- 复核机构号
            ,apprv_tell_num -- 审批柜员号
            ,apprv_org_id -- 审批机构号
            ,memo -- 审批备注
            ,bak1 -- 备注字段1
            ,bak2 -- 备注字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.txn_dt, o.txn_dt) as txn_dt -- 交易日期
    ,nvl(n.txn_tms, o.txn_tms) as txn_tms -- 交易时间
    ,nvl(n.txn_cd, o.txn_cd) as txn_cd -- 中台交易码
    ,nvl(n.trx_seq, o.trx_seq) as trx_seq -- 交易流水号
    ,nvl(n.app_dt, o.app_dt) as app_dt -- 操作日期
    ,nvl(n.app_tm, o.app_tm) as app_tm -- 操作日期
    ,nvl(n.app_id, o.app_id) as app_id -- 申请编号
    ,nvl(n.app_ord_nbr, o.app_ord_nbr) as app_ord_nbr -- 申请序号
    ,nvl(n.merch_status, o.merch_status) as merch_status -- 商户状态：0:未启用、1:已启用、2:已停用
    ,nvl(n.aprv_status, o.aprv_status) as aprv_status -- 审批状态:0:待提交、1:待审批、2:已通过、3:未通过
    ,nvl(n.txn_typ, o.txn_typ) as txn_typ -- 操作类型：0:商户注册、1:信息变更、2:服务变更
    ,nvl(n.merch_id, o.merch_id) as merch_id -- 商户编号
    ,nvl(n.merch_name, o.merch_name) as merch_name -- 商户名称
    ,nvl(n.regu_mode, o.regu_mode) as regu_mode -- 监管模式：01银行存管模式、02风险储备金模式、03复合模式；
    ,nvl(n.acct_typ, o.acct_typ) as acct_typ -- 账户类型 01:监管账户 02:保证金账户
    ,nvl(n.regu_acct_num, o.regu_acct_num) as regu_acct_num -- 监管账号信息-账号
    ,nvl(n.regu_act_nm, o.regu_act_nm) as regu_act_nm -- 监管账号信息-户名
    ,nvl(n.regu_open_bk_name, o.regu_open_bk_name) as regu_open_bk_name -- 监管账号信息-开户行名称
    ,nvl(n.regu_open_bk_num, o.regu_open_bk_num) as regu_open_bk_num -- 监管账号信息-开户行行号
    ,nvl(n.acct_typ_cd, o.acct_typ_cd) as acct_typ_cd -- 账户类型 01:监管账户 02:保证金账户
    ,nvl(n.marg_acct_num, o.marg_acct_num) as marg_acct_num -- 保证金账号信息-账号
    ,nvl(n.marg_act_nm, o.marg_act_nm) as marg_act_nm -- 保证金账号信息-户名
    ,nvl(n.marg_open_bk_name, o.marg_open_bk_name) as marg_open_bk_name -- 保证金账号信息-开户行名称
    ,nvl(n.marg_open_bk_num, o.marg_open_bk_num) as marg_open_bk_num -- 保证金账号信息-开户行行号
    ,nvl(n.corp_name, o.corp_name) as corp_name -- 基本信息-公司名称
    ,nvl(n.csld_soci_crdt_cd, o.csld_soci_crdt_cd) as csld_soci_crdt_cd -- 基本信息-统一社会信用代码
    ,nvl(n.corp_login_addr, o.corp_login_addr) as corp_login_addr -- 基本信息-注册地址
    ,nvl(n.clog_addr, o.clog_addr) as clog_addr -- 基本信息-办学地址
    ,nvl(n.corp_estab_dt, o.corp_estab_dt) as corp_estab_dt -- 基本信息-成立日期
    ,nvl(n.corp_tel_num, o.corp_tel_num) as corp_tel_num -- 基本信息-办公电话
    ,nvl(n.oper_scope, o.oper_scope) as oper_scope -- 基本信息-经营范围
    ,nvl(n.oper_licence_url, o.oper_licence_url) as oper_licence_url -- 基本信息-营业执照URL地址
    ,nvl(n.qlfy_proof_url, o.qlfy_proof_url) as qlfy_proof_url -- 基本信息-资质证明URL地址
    ,nvl(n.blng_bran_num, o.blng_bran_num) as blng_bran_num -- 管理职责-归属分行行号
    ,nvl(n.blng_bran_name, o.blng_bran_name) as blng_bran_name -- 管理职责-归属分行名称
    ,nvl(n.lp_name, o.lp_name) as lp_name -- 法人代表信息-姓名
    ,nvl(n.lp_cert_typ, o.lp_cert_typ) as lp_cert_typ -- 法人代表信息-证件类型
    ,nvl(n.lp_iden_num, o.lp_iden_num) as lp_iden_num -- 法人代表信息-身份证号码
    ,nvl(n.lp_ceph_num, o.lp_ceph_num) as lp_ceph_num -- 法人代表信息-手机号码
    ,nvl(n.lp_iden_fro_url, o.lp_iden_fro_url) as lp_iden_fro_url -- 法人身份证正面URL地址
    ,nvl(n.lp_iden_obv_url, o.lp_iden_obv_url) as lp_iden_obv_url -- 法人身份证反面URL地址
    ,nvl(n.oprt_name, o.oprt_name) as oprt_name -- 经办人信息-姓名
    ,nvl(n.oprt_ceph_num, o.oprt_ceph_num) as oprt_ceph_num -- 经办人信息-手机号码
    ,nvl(n.oprt_cert_typ, o.oprt_cert_typ) as oprt_cert_typ -- 经办人信息-证件类型
    ,nvl(n.oprt_cert_num, o.oprt_cert_num) as oprt_cert_num -- 经办人信息-证件号码
    ,nvl(n.oprt_cert_url, o.oprt_cert_url) as oprt_cert_url -- 经办人链接地址
    ,nvl(n.oprt_cert_print_piece_url, o.oprt_cert_print_piece_url) as oprt_cert_print_piece_url -- 经办人打印链接地址
    ,nvl(n.aprv_comnt, o.aprv_comnt) as aprv_comnt -- 审批人意见
    ,nvl(n.input_tell_num, o.input_tell_num) as input_tell_num -- 录入柜员号
    ,nvl(n.input_org_id, o.input_org_id) as input_org_id -- 录入机构号
    ,nvl(n.check_tell_num, o.check_tell_num) as check_tell_num -- 复核柜员号
    ,nvl(n.check_org_id, o.check_org_id) as check_org_id -- 复核机构号
    ,nvl(n.apprv_tell_num, o.apprv_tell_num) as apprv_tell_num -- 审批柜员号
    ,nvl(n.apprv_org_id, o.apprv_org_id) as apprv_org_id -- 审批机构号
    ,nvl(n.memo, o.memo) as memo -- 审批备注
    ,nvl(n.bak1, o.bak1) as bak1 -- 备注字段1
    ,nvl(n.bak2, o.bak2) as bak2 -- 备注字段2
    ,case when
            n.txn_dt is null
            and n.trx_seq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.txn_dt is null
            and n.trx_seq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.txn_dt is null
            and n.trx_seq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a1usetpsignacctinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a1usetpsignacctinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.txn_dt = n.txn_dt
            and o.trx_seq = n.trx_seq
where (
        o.txn_dt is null
        and o.trx_seq is null
    )
    or (
        n.txn_dt is null
        and n.trx_seq is null
    )
    or (
        o.txn_tms <> n.txn_tms
        or o.txn_cd <> n.txn_cd
        or o.app_dt <> n.app_dt
        or o.app_tm <> n.app_tm
        or o.app_id <> n.app_id
        or o.app_ord_nbr <> n.app_ord_nbr
        or o.merch_status <> n.merch_status
        or o.aprv_status <> n.aprv_status
        or o.txn_typ <> n.txn_typ
        or o.merch_id <> n.merch_id
        or o.merch_name <> n.merch_name
        or o.regu_mode <> n.regu_mode
        or o.acct_typ <> n.acct_typ
        or o.regu_acct_num <> n.regu_acct_num
        or o.regu_act_nm <> n.regu_act_nm
        or o.regu_open_bk_name <> n.regu_open_bk_name
        or o.regu_open_bk_num <> n.regu_open_bk_num
        or o.acct_typ_cd <> n.acct_typ_cd
        or o.marg_acct_num <> n.marg_acct_num
        or o.marg_act_nm <> n.marg_act_nm
        or o.marg_open_bk_name <> n.marg_open_bk_name
        or o.marg_open_bk_num <> n.marg_open_bk_num
        or o.corp_name <> n.corp_name
        or o.csld_soci_crdt_cd <> n.csld_soci_crdt_cd
        or o.corp_login_addr <> n.corp_login_addr
        or o.clog_addr <> n.clog_addr
        or o.corp_estab_dt <> n.corp_estab_dt
        or o.corp_tel_num <> n.corp_tel_num
        or o.oper_scope <> n.oper_scope
        or o.oper_licence_url <> n.oper_licence_url
        or o.qlfy_proof_url <> n.qlfy_proof_url
        or o.blng_bran_num <> n.blng_bran_num
        or o.blng_bran_name <> n.blng_bran_name
        or o.lp_name <> n.lp_name
        or o.lp_cert_typ <> n.lp_cert_typ
        or o.lp_iden_num <> n.lp_iden_num
        or o.lp_ceph_num <> n.lp_ceph_num
        or o.lp_iden_fro_url <> n.lp_iden_fro_url
        or o.lp_iden_obv_url <> n.lp_iden_obv_url
        or o.oprt_name <> n.oprt_name
        or o.oprt_ceph_num <> n.oprt_ceph_num
        or o.oprt_cert_typ <> n.oprt_cert_typ
        or o.oprt_cert_num <> n.oprt_cert_num
        or o.oprt_cert_url <> n.oprt_cert_url
        or o.oprt_cert_print_piece_url <> n.oprt_cert_print_piece_url
        or o.aprv_comnt <> n.aprv_comnt
        or o.input_tell_num <> n.input_tell_num
        or o.input_org_id <> n.input_org_id
        or o.check_tell_num <> n.check_tell_num
        or o.check_org_id <> n.check_org_id
        or o.apprv_tell_num <> n.apprv_tell_num
        or o.apprv_org_id <> n.apprv_org_id
        or o.memo <> n.memo
        or o.bak1 <> n.bak1
        or o.bak2 <> n.bak2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a1usetpsignacctinfo_cl(
            txn_dt -- 交易日期
            ,txn_tms -- 交易时间
            ,txn_cd -- 中台交易码
            ,trx_seq -- 交易流水号
            ,app_dt -- 操作日期
            ,app_tm -- 操作日期
            ,app_id -- 申请编号
            ,app_ord_nbr -- 申请序号
            ,merch_status -- 商户状态：0:未启用、1:已启用、2:已停用
            ,aprv_status -- 审批状态:0:待提交、1:待审批、2:已通过、3:未通过
            ,txn_typ -- 操作类型：0:商户注册、1:信息变更、2:服务变更
            ,merch_id -- 商户编号
            ,merch_name -- 商户名称
            ,regu_mode -- 监管模式：01银行存管模式、02风险储备金模式、03复合模式；
            ,acct_typ -- 账户类型 01:监管账户 02:保证金账户
            ,regu_acct_num -- 监管账号信息-账号
            ,regu_act_nm -- 监管账号信息-户名
            ,regu_open_bk_name -- 监管账号信息-开户行名称
            ,regu_open_bk_num -- 监管账号信息-开户行行号
            ,acct_typ_cd -- 账户类型 01:监管账户 02:保证金账户
            ,marg_acct_num -- 保证金账号信息-账号
            ,marg_act_nm -- 保证金账号信息-户名
            ,marg_open_bk_name -- 保证金账号信息-开户行名称
            ,marg_open_bk_num -- 保证金账号信息-开户行行号
            ,corp_name -- 基本信息-公司名称
            ,csld_soci_crdt_cd -- 基本信息-统一社会信用代码
            ,corp_login_addr -- 基本信息-注册地址
            ,clog_addr -- 基本信息-办学地址
            ,corp_estab_dt -- 基本信息-成立日期
            ,corp_tel_num -- 基本信息-办公电话
            ,oper_scope -- 基本信息-经营范围
            ,oper_licence_url -- 基本信息-营业执照URL地址
            ,qlfy_proof_url -- 基本信息-资质证明URL地址
            ,blng_bran_num -- 管理职责-归属分行行号
            ,blng_bran_name -- 管理职责-归属分行名称
            ,lp_name -- 法人代表信息-姓名
            ,lp_cert_typ -- 法人代表信息-证件类型
            ,lp_iden_num -- 法人代表信息-身份证号码
            ,lp_ceph_num -- 法人代表信息-手机号码
            ,lp_iden_fro_url -- 法人身份证正面URL地址
            ,lp_iden_obv_url -- 法人身份证反面URL地址
            ,oprt_name -- 经办人信息-姓名
            ,oprt_ceph_num -- 经办人信息-手机号码
            ,oprt_cert_typ -- 经办人信息-证件类型
            ,oprt_cert_num -- 经办人信息-证件号码
            ,oprt_cert_url -- 经办人链接地址
            ,oprt_cert_print_piece_url -- 经办人打印链接地址
            ,aprv_comnt -- 审批人意见
            ,input_tell_num -- 录入柜员号
            ,input_org_id -- 录入机构号
            ,check_tell_num -- 复核柜员号
            ,check_org_id -- 复核机构号
            ,apprv_tell_num -- 审批柜员号
            ,apprv_org_id -- 审批机构号
            ,memo -- 审批备注
            ,bak1 -- 备注字段1
            ,bak2 -- 备注字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a1usetpsignacctinfo_op(
            txn_dt -- 交易日期
            ,txn_tms -- 交易时间
            ,txn_cd -- 中台交易码
            ,trx_seq -- 交易流水号
            ,app_dt -- 操作日期
            ,app_tm -- 操作日期
            ,app_id -- 申请编号
            ,app_ord_nbr -- 申请序号
            ,merch_status -- 商户状态：0:未启用、1:已启用、2:已停用
            ,aprv_status -- 审批状态:0:待提交、1:待审批、2:已通过、3:未通过
            ,txn_typ -- 操作类型：0:商户注册、1:信息变更、2:服务变更
            ,merch_id -- 商户编号
            ,merch_name -- 商户名称
            ,regu_mode -- 监管模式：01银行存管模式、02风险储备金模式、03复合模式；
            ,acct_typ -- 账户类型 01:监管账户 02:保证金账户
            ,regu_acct_num -- 监管账号信息-账号
            ,regu_act_nm -- 监管账号信息-户名
            ,regu_open_bk_name -- 监管账号信息-开户行名称
            ,regu_open_bk_num -- 监管账号信息-开户行行号
            ,acct_typ_cd -- 账户类型 01:监管账户 02:保证金账户
            ,marg_acct_num -- 保证金账号信息-账号
            ,marg_act_nm -- 保证金账号信息-户名
            ,marg_open_bk_name -- 保证金账号信息-开户行名称
            ,marg_open_bk_num -- 保证金账号信息-开户行行号
            ,corp_name -- 基本信息-公司名称
            ,csld_soci_crdt_cd -- 基本信息-统一社会信用代码
            ,corp_login_addr -- 基本信息-注册地址
            ,clog_addr -- 基本信息-办学地址
            ,corp_estab_dt -- 基本信息-成立日期
            ,corp_tel_num -- 基本信息-办公电话
            ,oper_scope -- 基本信息-经营范围
            ,oper_licence_url -- 基本信息-营业执照URL地址
            ,qlfy_proof_url -- 基本信息-资质证明URL地址
            ,blng_bran_num -- 管理职责-归属分行行号
            ,blng_bran_name -- 管理职责-归属分行名称
            ,lp_name -- 法人代表信息-姓名
            ,lp_cert_typ -- 法人代表信息-证件类型
            ,lp_iden_num -- 法人代表信息-身份证号码
            ,lp_ceph_num -- 法人代表信息-手机号码
            ,lp_iden_fro_url -- 法人身份证正面URL地址
            ,lp_iden_obv_url -- 法人身份证反面URL地址
            ,oprt_name -- 经办人信息-姓名
            ,oprt_ceph_num -- 经办人信息-手机号码
            ,oprt_cert_typ -- 经办人信息-证件类型
            ,oprt_cert_num -- 经办人信息-证件号码
            ,oprt_cert_url -- 经办人链接地址
            ,oprt_cert_print_piece_url -- 经办人打印链接地址
            ,aprv_comnt -- 审批人意见
            ,input_tell_num -- 录入柜员号
            ,input_org_id -- 录入机构号
            ,check_tell_num -- 复核柜员号
            ,check_org_id -- 复核机构号
            ,apprv_tell_num -- 审批柜员号
            ,apprv_org_id -- 审批机构号
            ,memo -- 审批备注
            ,bak1 -- 备注字段1
            ,bak2 -- 备注字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.txn_dt -- 交易日期
    ,o.txn_tms -- 交易时间
    ,o.txn_cd -- 中台交易码
    ,o.trx_seq -- 交易流水号
    ,o.app_dt -- 操作日期
    ,o.app_tm -- 操作日期
    ,o.app_id -- 申请编号
    ,o.app_ord_nbr -- 申请序号
    ,o.merch_status -- 商户状态：0:未启用、1:已启用、2:已停用
    ,o.aprv_status -- 审批状态:0:待提交、1:待审批、2:已通过、3:未通过
    ,o.txn_typ -- 操作类型：0:商户注册、1:信息变更、2:服务变更
    ,o.merch_id -- 商户编号
    ,o.merch_name -- 商户名称
    ,o.regu_mode -- 监管模式：01银行存管模式、02风险储备金模式、03复合模式；
    ,o.acct_typ -- 账户类型 01:监管账户 02:保证金账户
    ,o.regu_acct_num -- 监管账号信息-账号
    ,o.regu_act_nm -- 监管账号信息-户名
    ,o.regu_open_bk_name -- 监管账号信息-开户行名称
    ,o.regu_open_bk_num -- 监管账号信息-开户行行号
    ,o.acct_typ_cd -- 账户类型 01:监管账户 02:保证金账户
    ,o.marg_acct_num -- 保证金账号信息-账号
    ,o.marg_act_nm -- 保证金账号信息-户名
    ,o.marg_open_bk_name -- 保证金账号信息-开户行名称
    ,o.marg_open_bk_num -- 保证金账号信息-开户行行号
    ,o.corp_name -- 基本信息-公司名称
    ,o.csld_soci_crdt_cd -- 基本信息-统一社会信用代码
    ,o.corp_login_addr -- 基本信息-注册地址
    ,o.clog_addr -- 基本信息-办学地址
    ,o.corp_estab_dt -- 基本信息-成立日期
    ,o.corp_tel_num -- 基本信息-办公电话
    ,o.oper_scope -- 基本信息-经营范围
    ,o.oper_licence_url -- 基本信息-营业执照URL地址
    ,o.qlfy_proof_url -- 基本信息-资质证明URL地址
    ,o.blng_bran_num -- 管理职责-归属分行行号
    ,o.blng_bran_name -- 管理职责-归属分行名称
    ,o.lp_name -- 法人代表信息-姓名
    ,o.lp_cert_typ -- 法人代表信息-证件类型
    ,o.lp_iden_num -- 法人代表信息-身份证号码
    ,o.lp_ceph_num -- 法人代表信息-手机号码
    ,o.lp_iden_fro_url -- 法人身份证正面URL地址
    ,o.lp_iden_obv_url -- 法人身份证反面URL地址
    ,o.oprt_name -- 经办人信息-姓名
    ,o.oprt_ceph_num -- 经办人信息-手机号码
    ,o.oprt_cert_typ -- 经办人信息-证件类型
    ,o.oprt_cert_num -- 经办人信息-证件号码
    ,o.oprt_cert_url -- 经办人链接地址
    ,o.oprt_cert_print_piece_url -- 经办人打印链接地址
    ,o.aprv_comnt -- 审批人意见
    ,o.input_tell_num -- 录入柜员号
    ,o.input_org_id -- 录入机构号
    ,o.check_tell_num -- 复核柜员号
    ,o.check_org_id -- 复核机构号
    ,o.apprv_tell_num -- 审批柜员号
    ,o.apprv_org_id -- 审批机构号
    ,o.memo -- 审批备注
    ,o.bak1 -- 备注字段1
    ,o.bak2 -- 备注字段2
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
from ${iol_schema}.mpcs_a1usetpsignacctinfo_bk o
    left join ${iol_schema}.mpcs_a1usetpsignacctinfo_op n
        on
            o.txn_dt = n.txn_dt
            and o.trx_seq = n.trx_seq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a1usetpsignacctinfo_cl d
        on
            o.txn_dt = d.txn_dt
            and o.trx_seq = d.trx_seq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a1usetpsignacctinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a1usetpsignacctinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a1usetpsignacctinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a1usetpsignacctinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a1usetpsignacctinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a1usetpsignacctinfo_cl;
alter table ${iol_schema}.mpcs_a1usetpsignacctinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a1usetpsignacctinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a1usetpsignacctinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a1usetpsignacctinfo_op purge;
drop table ${iol_schema}.mpcs_a1usetpsignacctinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a1usetpsignacctinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a1usetpsignacctinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
