/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_cst_inf
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
create table ${iol_schema}.tbps_cpr_cst_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_cst_inf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_cst_inf_op purge;
drop table ${iol_schema}.tbps_cpr_cst_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_cst_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_cst_inf where 0=1;

create table ${iol_schema}.tbps_cpr_cst_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_cst_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_cst_inf_cl(
            cif_ecifno -- 全行统一客户号
            ,cif_ctftyp -- 证件类型
            ,cif_ctfno -- 证件号码
            ,cif_namecn -- 客户名称（中文）
            ,cif_nameen -- 客户名称(英文)
            ,cif_groupflag -- 0：非集团客户，1：集团客户（默认为0）
            ,cif_custflag -- 0：虚拟客户1：交易银行客户2：网银客户3：交易银行+网银客户4：佳佳购车客户7：银企直连（默认为:1）
            ,cif_srclevel -- 0：查询版，1：普通版（默认为:1）
            ,cif_address -- 企业地址
            ,cif_feeaccount -- 收费账号
            ,cif_feecurrency -- 收费账号币种，默认“CNY”
            ,cif_zipcode -- 邮政编码
            ,cif_phone -- 电话
            ,cif_fax -- 传真
            ,cif_email -- Email
            ,cif_opentime -- 开户时间
            ,cif_lastupdatetime -- 最后更新时间
            ,cif_stt -- 0：正常1：锁定(允许查询)2：冻结 (不允许查询)3：销户（默认为0）
            ,cif_remark -- 状态备注
            ,cif_orgid -- 组织机构代码
            ,cif_legalname -- 法人代表名称
            ,cif_legalcerttype -- 法人证件类型
            ,cif_legalcertno -- 法人证件号码
            ,cif_legalphone -- 法人电话号码
            ,cif_rmcode -- 客户经理编号
            ,cif_openbranch -- 开户分行
            ,cif_opendept -- 开户网点
            ,cif_businessnode -- 业务归属网点
            ,cif_openteller -- 开户操作员号
            ,cif_cashcontrolflag -- 现金控制标识(默认为：0)
            ,cif_legalcardenddate -- 法人证件到期日
            ,supplychainflag -- 供应链系统标识
            ,cif_mobilebank_open -- 签约银企通，1:是 0:否
            ,cif_mobilebank_opentime -- 签约银企通时间
            ,cif_canceloatime -- OA注销时间
            ,cif_oldaono -- 原OA编号
            ,cif_expense_account -- OA报销关联账户
            ,cif_cloudshield_open -- 云盾开通标志(0:注销;1:开通)
            ,cif_cloudshield_opentime -- 云盾开通时间
            ,cif_openchannel -- 操作员新增渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_cst_inf_op(
            cif_ecifno -- 全行统一客户号
            ,cif_ctftyp -- 证件类型
            ,cif_ctfno -- 证件号码
            ,cif_namecn -- 客户名称（中文）
            ,cif_nameen -- 客户名称(英文)
            ,cif_groupflag -- 0：非集团客户，1：集团客户（默认为0）
            ,cif_custflag -- 0：虚拟客户1：交易银行客户2：网银客户3：交易银行+网银客户4：佳佳购车客户7：银企直连（默认为:1）
            ,cif_srclevel -- 0：查询版，1：普通版（默认为:1）
            ,cif_address -- 企业地址
            ,cif_feeaccount -- 收费账号
            ,cif_feecurrency -- 收费账号币种，默认“CNY”
            ,cif_zipcode -- 邮政编码
            ,cif_phone -- 电话
            ,cif_fax -- 传真
            ,cif_email -- Email
            ,cif_opentime -- 开户时间
            ,cif_lastupdatetime -- 最后更新时间
            ,cif_stt -- 0：正常1：锁定(允许查询)2：冻结 (不允许查询)3：销户（默认为0）
            ,cif_remark -- 状态备注
            ,cif_orgid -- 组织机构代码
            ,cif_legalname -- 法人代表名称
            ,cif_legalcerttype -- 法人证件类型
            ,cif_legalcertno -- 法人证件号码
            ,cif_legalphone -- 法人电话号码
            ,cif_rmcode -- 客户经理编号
            ,cif_openbranch -- 开户分行
            ,cif_opendept -- 开户网点
            ,cif_businessnode -- 业务归属网点
            ,cif_openteller -- 开户操作员号
            ,cif_cashcontrolflag -- 现金控制标识(默认为：0)
            ,cif_legalcardenddate -- 法人证件到期日
            ,supplychainflag -- 供应链系统标识
            ,cif_mobilebank_open -- 签约银企通，1:是 0:否
            ,cif_mobilebank_opentime -- 签约银企通时间
            ,cif_canceloatime -- OA注销时间
            ,cif_oldaono -- 原OA编号
            ,cif_expense_account -- OA报销关联账户
            ,cif_cloudshield_open -- 云盾开通标志(0:注销;1:开通)
            ,cif_cloudshield_opentime -- 云盾开通时间
            ,cif_openchannel -- 操作员新增渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cif_ecifno, o.cif_ecifno) as cif_ecifno -- 全行统一客户号
    ,nvl(n.cif_ctftyp, o.cif_ctftyp) as cif_ctftyp -- 证件类型
    ,nvl(n.cif_ctfno, o.cif_ctfno) as cif_ctfno -- 证件号码
    ,nvl(n.cif_namecn, o.cif_namecn) as cif_namecn -- 客户名称（中文）
    ,nvl(n.cif_nameen, o.cif_nameen) as cif_nameen -- 客户名称(英文)
    ,nvl(n.cif_groupflag, o.cif_groupflag) as cif_groupflag -- 0：非集团客户，1：集团客户（默认为0）
    ,nvl(n.cif_custflag, o.cif_custflag) as cif_custflag -- 0：虚拟客户1：交易银行客户2：网银客户3：交易银行+网银客户4：佳佳购车客户7：银企直连（默认为:1）
    ,nvl(n.cif_srclevel, o.cif_srclevel) as cif_srclevel -- 0：查询版，1：普通版（默认为:1）
    ,nvl(n.cif_address, o.cif_address) as cif_address -- 企业地址
    ,nvl(n.cif_feeaccount, o.cif_feeaccount) as cif_feeaccount -- 收费账号
    ,nvl(n.cif_feecurrency, o.cif_feecurrency) as cif_feecurrency -- 收费账号币种，默认“CNY”
    ,nvl(n.cif_zipcode, o.cif_zipcode) as cif_zipcode -- 邮政编码
    ,nvl(n.cif_phone, o.cif_phone) as cif_phone -- 电话
    ,nvl(n.cif_fax, o.cif_fax) as cif_fax -- 传真
    ,nvl(n.cif_email, o.cif_email) as cif_email -- Email
    ,nvl(n.cif_opentime, o.cif_opentime) as cif_opentime -- 开户时间
    ,nvl(n.cif_lastupdatetime, o.cif_lastupdatetime) as cif_lastupdatetime -- 最后更新时间
    ,nvl(n.cif_stt, o.cif_stt) as cif_stt -- 0：正常1：锁定(允许查询)2：冻结 (不允许查询)3：销户（默认为0）
    ,nvl(n.cif_remark, o.cif_remark) as cif_remark -- 状态备注
    ,nvl(n.cif_orgid, o.cif_orgid) as cif_orgid -- 组织机构代码
    ,nvl(n.cif_legalname, o.cif_legalname) as cif_legalname -- 法人代表名称
    ,nvl(n.cif_legalcerttype, o.cif_legalcerttype) as cif_legalcerttype -- 法人证件类型
    ,nvl(n.cif_legalcertno, o.cif_legalcertno) as cif_legalcertno -- 法人证件号码
    ,nvl(n.cif_legalphone, o.cif_legalphone) as cif_legalphone -- 法人电话号码
    ,nvl(n.cif_rmcode, o.cif_rmcode) as cif_rmcode -- 客户经理编号
    ,nvl(n.cif_openbranch, o.cif_openbranch) as cif_openbranch -- 开户分行
    ,nvl(n.cif_opendept, o.cif_opendept) as cif_opendept -- 开户网点
    ,nvl(n.cif_businessnode, o.cif_businessnode) as cif_businessnode -- 业务归属网点
    ,nvl(n.cif_openteller, o.cif_openteller) as cif_openteller -- 开户操作员号
    ,nvl(n.cif_cashcontrolflag, o.cif_cashcontrolflag) as cif_cashcontrolflag -- 现金控制标识(默认为：0)
    ,nvl(n.cif_legalcardenddate, o.cif_legalcardenddate) as cif_legalcardenddate -- 法人证件到期日
    ,nvl(n.supplychainflag, o.supplychainflag) as supplychainflag -- 供应链系统标识
    ,nvl(n.cif_mobilebank_open, o.cif_mobilebank_open) as cif_mobilebank_open -- 签约银企通，1:是 0:否
    ,nvl(n.cif_mobilebank_opentime, o.cif_mobilebank_opentime) as cif_mobilebank_opentime -- 签约银企通时间
    ,nvl(n.cif_canceloatime, o.cif_canceloatime) as cif_canceloatime -- OA注销时间
    ,nvl(n.cif_oldaono, o.cif_oldaono) as cif_oldaono -- 原OA编号
    ,nvl(n.cif_expense_account, o.cif_expense_account) as cif_expense_account -- OA报销关联账户
    ,nvl(n.cif_cloudshield_open, o.cif_cloudshield_open) as cif_cloudshield_open -- 云盾开通标志(0:注销;1:开通)
    ,nvl(n.cif_cloudshield_opentime, o.cif_cloudshield_opentime) as cif_cloudshield_opentime -- 云盾开通时间
    ,nvl(n.cif_openchannel, o.cif_openchannel) as cif_openchannel -- 操作员新增渠道
    ,case when
            n.cif_ecifno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cif_ecifno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cif_ecifno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_cst_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_cst_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cif_ecifno = n.cif_ecifno
where (
        o.cif_ecifno is null
    )
    or (
        n.cif_ecifno is null
    )
    or (
        o.cif_ctftyp <> n.cif_ctftyp
        or o.cif_ctfno <> n.cif_ctfno
        or o.cif_namecn <> n.cif_namecn
        or o.cif_nameen <> n.cif_nameen
        or o.cif_groupflag <> n.cif_groupflag
        or o.cif_custflag <> n.cif_custflag
        or o.cif_srclevel <> n.cif_srclevel
        or o.cif_address <> n.cif_address
        or o.cif_feeaccount <> n.cif_feeaccount
        or o.cif_feecurrency <> n.cif_feecurrency
        or o.cif_zipcode <> n.cif_zipcode
        or o.cif_phone <> n.cif_phone
        or o.cif_fax <> n.cif_fax
        or o.cif_email <> n.cif_email
        or o.cif_opentime <> n.cif_opentime
        or o.cif_lastupdatetime <> n.cif_lastupdatetime
        or o.cif_stt <> n.cif_stt
        or o.cif_remark <> n.cif_remark
        or o.cif_orgid <> n.cif_orgid
        or o.cif_legalname <> n.cif_legalname
        or o.cif_legalcerttype <> n.cif_legalcerttype
        or o.cif_legalcertno <> n.cif_legalcertno
        or o.cif_legalphone <> n.cif_legalphone
        or o.cif_rmcode <> n.cif_rmcode
        or o.cif_openbranch <> n.cif_openbranch
        or o.cif_opendept <> n.cif_opendept
        or o.cif_businessnode <> n.cif_businessnode
        or o.cif_openteller <> n.cif_openteller
        or o.cif_cashcontrolflag <> n.cif_cashcontrolflag
        or o.cif_legalcardenddate <> n.cif_legalcardenddate
        or o.supplychainflag <> n.supplychainflag
        or o.cif_mobilebank_open <> n.cif_mobilebank_open
        or o.cif_mobilebank_opentime <> n.cif_mobilebank_opentime
        or o.cif_canceloatime <> n.cif_canceloatime
        or o.cif_oldaono <> n.cif_oldaono
        or o.cif_expense_account <> n.cif_expense_account
        or o.cif_cloudshield_open <> n.cif_cloudshield_open
        or o.cif_cloudshield_opentime <> n.cif_cloudshield_opentime
        or o.cif_openchannel <> n.cif_openchannel
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_cst_inf_cl(
            cif_ecifno -- 全行统一客户号
            ,cif_ctftyp -- 证件类型
            ,cif_ctfno -- 证件号码
            ,cif_namecn -- 客户名称（中文）
            ,cif_nameen -- 客户名称(英文)
            ,cif_groupflag -- 0：非集团客户，1：集团客户（默认为0）
            ,cif_custflag -- 0：虚拟客户1：交易银行客户2：网银客户3：交易银行+网银客户4：佳佳购车客户7：银企直连（默认为:1）
            ,cif_srclevel -- 0：查询版，1：普通版（默认为:1）
            ,cif_address -- 企业地址
            ,cif_feeaccount -- 收费账号
            ,cif_feecurrency -- 收费账号币种，默认“CNY”
            ,cif_zipcode -- 邮政编码
            ,cif_phone -- 电话
            ,cif_fax -- 传真
            ,cif_email -- Email
            ,cif_opentime -- 开户时间
            ,cif_lastupdatetime -- 最后更新时间
            ,cif_stt -- 0：正常1：锁定(允许查询)2：冻结 (不允许查询)3：销户（默认为0）
            ,cif_remark -- 状态备注
            ,cif_orgid -- 组织机构代码
            ,cif_legalname -- 法人代表名称
            ,cif_legalcerttype -- 法人证件类型
            ,cif_legalcertno -- 法人证件号码
            ,cif_legalphone -- 法人电话号码
            ,cif_rmcode -- 客户经理编号
            ,cif_openbranch -- 开户分行
            ,cif_opendept -- 开户网点
            ,cif_businessnode -- 业务归属网点
            ,cif_openteller -- 开户操作员号
            ,cif_cashcontrolflag -- 现金控制标识(默认为：0)
            ,cif_legalcardenddate -- 法人证件到期日
            ,supplychainflag -- 供应链系统标识
            ,cif_mobilebank_open -- 签约银企通，1:是 0:否
            ,cif_mobilebank_opentime -- 签约银企通时间
            ,cif_canceloatime -- OA注销时间
            ,cif_oldaono -- 原OA编号
            ,cif_expense_account -- OA报销关联账户
            ,cif_cloudshield_open -- 云盾开通标志(0:注销;1:开通)
            ,cif_cloudshield_opentime -- 云盾开通时间
            ,cif_openchannel -- 操作员新增渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_cst_inf_op(
            cif_ecifno -- 全行统一客户号
            ,cif_ctftyp -- 证件类型
            ,cif_ctfno -- 证件号码
            ,cif_namecn -- 客户名称（中文）
            ,cif_nameen -- 客户名称(英文)
            ,cif_groupflag -- 0：非集团客户，1：集团客户（默认为0）
            ,cif_custflag -- 0：虚拟客户1：交易银行客户2：网银客户3：交易银行+网银客户4：佳佳购车客户7：银企直连（默认为:1）
            ,cif_srclevel -- 0：查询版，1：普通版（默认为:1）
            ,cif_address -- 企业地址
            ,cif_feeaccount -- 收费账号
            ,cif_feecurrency -- 收费账号币种，默认“CNY”
            ,cif_zipcode -- 邮政编码
            ,cif_phone -- 电话
            ,cif_fax -- 传真
            ,cif_email -- Email
            ,cif_opentime -- 开户时间
            ,cif_lastupdatetime -- 最后更新时间
            ,cif_stt -- 0：正常1：锁定(允许查询)2：冻结 (不允许查询)3：销户（默认为0）
            ,cif_remark -- 状态备注
            ,cif_orgid -- 组织机构代码
            ,cif_legalname -- 法人代表名称
            ,cif_legalcerttype -- 法人证件类型
            ,cif_legalcertno -- 法人证件号码
            ,cif_legalphone -- 法人电话号码
            ,cif_rmcode -- 客户经理编号
            ,cif_openbranch -- 开户分行
            ,cif_opendept -- 开户网点
            ,cif_businessnode -- 业务归属网点
            ,cif_openteller -- 开户操作员号
            ,cif_cashcontrolflag -- 现金控制标识(默认为：0)
            ,cif_legalcardenddate -- 法人证件到期日
            ,supplychainflag -- 供应链系统标识
            ,cif_mobilebank_open -- 签约银企通，1:是 0:否
            ,cif_mobilebank_opentime -- 签约银企通时间
            ,cif_canceloatime -- OA注销时间
            ,cif_oldaono -- 原OA编号
            ,cif_expense_account -- OA报销关联账户
            ,cif_cloudshield_open -- 云盾开通标志(0:注销;1:开通)
            ,cif_cloudshield_opentime -- 云盾开通时间
            ,cif_openchannel -- 操作员新增渠道
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cif_ecifno -- 全行统一客户号
    ,o.cif_ctftyp -- 证件类型
    ,o.cif_ctfno -- 证件号码
    ,o.cif_namecn -- 客户名称（中文）
    ,o.cif_nameen -- 客户名称(英文)
    ,o.cif_groupflag -- 0：非集团客户，1：集团客户（默认为0）
    ,o.cif_custflag -- 0：虚拟客户1：交易银行客户2：网银客户3：交易银行+网银客户4：佳佳购车客户7：银企直连（默认为:1）
    ,o.cif_srclevel -- 0：查询版，1：普通版（默认为:1）
    ,o.cif_address -- 企业地址
    ,o.cif_feeaccount -- 收费账号
    ,o.cif_feecurrency -- 收费账号币种，默认“CNY”
    ,o.cif_zipcode -- 邮政编码
    ,o.cif_phone -- 电话
    ,o.cif_fax -- 传真
    ,o.cif_email -- Email
    ,o.cif_opentime -- 开户时间
    ,o.cif_lastupdatetime -- 最后更新时间
    ,o.cif_stt -- 0：正常1：锁定(允许查询)2：冻结 (不允许查询)3：销户（默认为0）
    ,o.cif_remark -- 状态备注
    ,o.cif_orgid -- 组织机构代码
    ,o.cif_legalname -- 法人代表名称
    ,o.cif_legalcerttype -- 法人证件类型
    ,o.cif_legalcertno -- 法人证件号码
    ,o.cif_legalphone -- 法人电话号码
    ,o.cif_rmcode -- 客户经理编号
    ,o.cif_openbranch -- 开户分行
    ,o.cif_opendept -- 开户网点
    ,o.cif_businessnode -- 业务归属网点
    ,o.cif_openteller -- 开户操作员号
    ,o.cif_cashcontrolflag -- 现金控制标识(默认为：0)
    ,o.cif_legalcardenddate -- 法人证件到期日
    ,o.supplychainflag -- 供应链系统标识
    ,o.cif_mobilebank_open -- 签约银企通，1:是 0:否
    ,o.cif_mobilebank_opentime -- 签约银企通时间
    ,o.cif_canceloatime -- OA注销时间
    ,o.cif_oldaono -- 原OA编号
    ,o.cif_expense_account -- OA报销关联账户
    ,o.cif_cloudshield_open -- 云盾开通标志(0:注销;1:开通)
    ,o.cif_cloudshield_opentime -- 云盾开通时间
    ,o.cif_openchannel -- 操作员新增渠道
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_cst_inf_bk o
    left join ${iol_schema}.tbps_cpr_cst_inf_op n
        on
            o.cif_ecifno = n.cif_ecifno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_cst_inf_cl d
        on
            o.cif_ecifno = d.cif_ecifno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_cst_inf;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_cst_inf exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_cst_inf_cl;
alter table ${iol_schema}.tbps_cpr_cst_inf exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_cst_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_cst_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_cst_inf_op purge;
drop table ${iol_schema}.tbps_cpr_cst_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_cst_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_cst_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
