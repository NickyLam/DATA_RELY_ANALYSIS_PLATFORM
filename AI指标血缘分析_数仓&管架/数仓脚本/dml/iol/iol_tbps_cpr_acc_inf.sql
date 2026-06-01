/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tbps_cpr_acc_inf
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
create table ${iol_schema}.tbps_cpr_acc_inf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tbps_cpr_acc_inf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_acc_inf_op purge;
drop table ${iol_schema}.tbps_cpr_acc_inf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_acc_inf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_acc_inf where 0=1;

create table ${iol_schema}.tbps_cpr_acc_inf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tbps_cpr_acc_inf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_acc_inf_cl(
            cai_cstno -- 企业客户号(ecif号)
            ,cai_ctftype -- 企业证件类型
            ,cai_ctfno -- 企业证件号
            ,cai_userno -- 录入操作员id(网银顺序号)
            ,cai_useralias -- 录入操作员别名(登录名)
            ,cai_accno -- 卡号/账号
            ,cai_acctype -- 账号类型（21-单位结算卡；类型可以扩展）
            ,cai_accname -- 户名
            ,cai_alias -- 账户别名
            ,cai_crflag -- 钞汇标志(c--钞;r--汇)
            ,cai_crytype -- 币种（cry人民币）
            ,cai_branchno -- 账户开户机构
            ,cai_state -- 状态(0：正常;1：网银删除;2：冻结;3：暂停)
            ,cai_signflag -- 账户签约标志（0：已签约；1：未签约）预留
            ,cai_signway -- 账户加挂方式（0:柜台签约1:交易银行pc签约2:交易银行app签约3:支付签约）
            ,cai_hide -- 是否隐藏(0：显示；1：隐藏；)
            ,cai_right -- 账户权限，8位，1-开通，0-未开通。第1位：单位结算卡,其他预留传0
            ,cai_sourcesys -- 来源系统(1:核心；1:电子账户系统)
            ,cai_firsttime -- 首次绑定时间
            ,cai_updatetime -- 更新时间
            ,cai_usetime -- 最近使用时间(从未使用则为注册时间，格式为yyyymmddhhmiss)
            ,cai_remark1 -- 预留字段1
            ,cai_remark2 -- 预留字段2
            ,cai_remark3 -- 预留字段3
            ,cai_closedate -- 账户解挂日期
            ,cai_opendate -- 核心开户时间
            ,cai_annualenddate -- 账号年检到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_acc_inf_op(
            cai_cstno -- 企业客户号(ecif号)
            ,cai_ctftype -- 企业证件类型
            ,cai_ctfno -- 企业证件号
            ,cai_userno -- 录入操作员id(网银顺序号)
            ,cai_useralias -- 录入操作员别名(登录名)
            ,cai_accno -- 卡号/账号
            ,cai_acctype -- 账号类型（21-单位结算卡；类型可以扩展）
            ,cai_accname -- 户名
            ,cai_alias -- 账户别名
            ,cai_crflag -- 钞汇标志(c--钞;r--汇)
            ,cai_crytype -- 币种（cry人民币）
            ,cai_branchno -- 账户开户机构
            ,cai_state -- 状态(0：正常;1：网银删除;2：冻结;3：暂停)
            ,cai_signflag -- 账户签约标志（0：已签约；1：未签约）预留
            ,cai_signway -- 账户加挂方式（0:柜台签约1:交易银行pc签约2:交易银行app签约3:支付签约）
            ,cai_hide -- 是否隐藏(0：显示；1：隐藏；)
            ,cai_right -- 账户权限，8位，1-开通，0-未开通。第1位：单位结算卡,其他预留传0
            ,cai_sourcesys -- 来源系统(1:核心；1:电子账户系统)
            ,cai_firsttime -- 首次绑定时间
            ,cai_updatetime -- 更新时间
            ,cai_usetime -- 最近使用时间(从未使用则为注册时间，格式为yyyymmddhhmiss)
            ,cai_remark1 -- 预留字段1
            ,cai_remark2 -- 预留字段2
            ,cai_remark3 -- 预留字段3
            ,cai_closedate -- 账户解挂日期
            ,cai_opendate -- 核心开户时间
            ,cai_annualenddate -- 账号年检到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cai_cstno, o.cai_cstno) as cai_cstno -- 企业客户号(ecif号)
    ,nvl(n.cai_ctftype, o.cai_ctftype) as cai_ctftype -- 企业证件类型
    ,nvl(n.cai_ctfno, o.cai_ctfno) as cai_ctfno -- 企业证件号
    ,nvl(n.cai_userno, o.cai_userno) as cai_userno -- 录入操作员id(网银顺序号)
    ,nvl(n.cai_useralias, o.cai_useralias) as cai_useralias -- 录入操作员别名(登录名)
    ,nvl(n.cai_accno, o.cai_accno) as cai_accno -- 卡号/账号
    ,nvl(n.cai_acctype, o.cai_acctype) as cai_acctype -- 账号类型（21-单位结算卡；类型可以扩展）
    ,nvl(n.cai_accname, o.cai_accname) as cai_accname -- 户名
    ,nvl(n.cai_alias, o.cai_alias) as cai_alias -- 账户别名
    ,nvl(n.cai_crflag, o.cai_crflag) as cai_crflag -- 钞汇标志(c--钞;r--汇)
    ,nvl(n.cai_crytype, o.cai_crytype) as cai_crytype -- 币种（cry人民币）
    ,nvl(n.cai_branchno, o.cai_branchno) as cai_branchno -- 账户开户机构
    ,nvl(n.cai_state, o.cai_state) as cai_state -- 状态(0：正常;1：网银删除;2：冻结;3：暂停)
    ,nvl(n.cai_signflag, o.cai_signflag) as cai_signflag -- 账户签约标志（0：已签约；1：未签约）预留
    ,nvl(n.cai_signway, o.cai_signway) as cai_signway -- 账户加挂方式（0:柜台签约1:交易银行pc签约2:交易银行app签约3:支付签约）
    ,nvl(n.cai_hide, o.cai_hide) as cai_hide -- 是否隐藏(0：显示；1：隐藏；)
    ,nvl(n.cai_right, o.cai_right) as cai_right -- 账户权限，8位，1-开通，0-未开通。第1位：单位结算卡,其他预留传0
    ,nvl(n.cai_sourcesys, o.cai_sourcesys) as cai_sourcesys -- 来源系统(1:核心；1:电子账户系统)
    ,nvl(n.cai_firsttime, o.cai_firsttime) as cai_firsttime -- 首次绑定时间
    ,nvl(n.cai_updatetime, o.cai_updatetime) as cai_updatetime -- 更新时间
    ,nvl(n.cai_usetime, o.cai_usetime) as cai_usetime -- 最近使用时间(从未使用则为注册时间，格式为yyyymmddhhmiss)
    ,nvl(n.cai_remark1, o.cai_remark1) as cai_remark1 -- 预留字段1
    ,nvl(n.cai_remark2, o.cai_remark2) as cai_remark2 -- 预留字段2
    ,nvl(n.cai_remark3, o.cai_remark3) as cai_remark3 -- 预留字段3
    ,nvl(n.cai_closedate, o.cai_closedate) as cai_closedate -- 账户解挂日期
    ,nvl(n.cai_opendate, o.cai_opendate) as cai_opendate -- 核心开户时间
    ,nvl(n.cai_annualenddate, o.cai_annualenddate) as cai_annualenddate -- 账号年检到期日
    ,case when
            n.cai_cstno is null
            and n.cai_accno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cai_cstno is null
            and n.cai_accno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cai_cstno is null
            and n.cai_accno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tbps_cpr_acc_inf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tbps_cpr_acc_inf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cai_cstno = n.cai_cstno
            and o.cai_accno = n.cai_accno
where (
        o.cai_cstno is null
        and o.cai_accno is null
    )
    or (
        n.cai_cstno is null
        and n.cai_accno is null
    )
    or (
        o.cai_ctftype <> n.cai_ctftype
        or o.cai_ctfno <> n.cai_ctfno
        or o.cai_userno <> n.cai_userno
        or o.cai_useralias <> n.cai_useralias
        or o.cai_acctype <> n.cai_acctype
        or o.cai_accname <> n.cai_accname
        or o.cai_alias <> n.cai_alias
        or o.cai_crflag <> n.cai_crflag
        or o.cai_crytype <> n.cai_crytype
        or o.cai_branchno <> n.cai_branchno
        or o.cai_state <> n.cai_state
        or o.cai_signflag <> n.cai_signflag
        or o.cai_signway <> n.cai_signway
        or o.cai_hide <> n.cai_hide
        or o.cai_right <> n.cai_right
        or o.cai_sourcesys <> n.cai_sourcesys
        or o.cai_firsttime <> n.cai_firsttime
        or o.cai_updatetime <> n.cai_updatetime
        or o.cai_usetime <> n.cai_usetime
        or o.cai_remark1 <> n.cai_remark1
        or o.cai_remark2 <> n.cai_remark2
        or o.cai_remark3 <> n.cai_remark3
        or o.cai_closedate <> n.cai_closedate
        or o.cai_opendate <> n.cai_opendate
        or o.cai_annualenddate <> n.cai_annualenddate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tbps_cpr_acc_inf_cl(
            cai_cstno -- 企业客户号(ecif号)
            ,cai_ctftype -- 企业证件类型
            ,cai_ctfno -- 企业证件号
            ,cai_userno -- 录入操作员id(网银顺序号)
            ,cai_useralias -- 录入操作员别名(登录名)
            ,cai_accno -- 卡号/账号
            ,cai_acctype -- 账号类型（21-单位结算卡；类型可以扩展）
            ,cai_accname -- 户名
            ,cai_alias -- 账户别名
            ,cai_crflag -- 钞汇标志(c--钞;r--汇)
            ,cai_crytype -- 币种（cry人民币）
            ,cai_branchno -- 账户开户机构
            ,cai_state -- 状态(0：正常;1：网银删除;2：冻结;3：暂停)
            ,cai_signflag -- 账户签约标志（0：已签约；1：未签约）预留
            ,cai_signway -- 账户加挂方式（0:柜台签约1:交易银行pc签约2:交易银行app签约3:支付签约）
            ,cai_hide -- 是否隐藏(0：显示；1：隐藏；)
            ,cai_right -- 账户权限，8位，1-开通，0-未开通。第1位：单位结算卡,其他预留传0
            ,cai_sourcesys -- 来源系统(1:核心；1:电子账户系统)
            ,cai_firsttime -- 首次绑定时间
            ,cai_updatetime -- 更新时间
            ,cai_usetime -- 最近使用时间(从未使用则为注册时间，格式为yyyymmddhhmiss)
            ,cai_remark1 -- 预留字段1
            ,cai_remark2 -- 预留字段2
            ,cai_remark3 -- 预留字段3
            ,cai_closedate -- 账户解挂日期
            ,cai_opendate -- 核心开户时间
            ,cai_annualenddate -- 账号年检到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tbps_cpr_acc_inf_op(
            cai_cstno -- 企业客户号(ecif号)
            ,cai_ctftype -- 企业证件类型
            ,cai_ctfno -- 企业证件号
            ,cai_userno -- 录入操作员id(网银顺序号)
            ,cai_useralias -- 录入操作员别名(登录名)
            ,cai_accno -- 卡号/账号
            ,cai_acctype -- 账号类型（21-单位结算卡；类型可以扩展）
            ,cai_accname -- 户名
            ,cai_alias -- 账户别名
            ,cai_crflag -- 钞汇标志(c--钞;r--汇)
            ,cai_crytype -- 币种（cry人民币）
            ,cai_branchno -- 账户开户机构
            ,cai_state -- 状态(0：正常;1：网银删除;2：冻结;3：暂停)
            ,cai_signflag -- 账户签约标志（0：已签约；1：未签约）预留
            ,cai_signway -- 账户加挂方式（0:柜台签约1:交易银行pc签约2:交易银行app签约3:支付签约）
            ,cai_hide -- 是否隐藏(0：显示；1：隐藏；)
            ,cai_right -- 账户权限，8位，1-开通，0-未开通。第1位：单位结算卡,其他预留传0
            ,cai_sourcesys -- 来源系统(1:核心；1:电子账户系统)
            ,cai_firsttime -- 首次绑定时间
            ,cai_updatetime -- 更新时间
            ,cai_usetime -- 最近使用时间(从未使用则为注册时间，格式为yyyymmddhhmiss)
            ,cai_remark1 -- 预留字段1
            ,cai_remark2 -- 预留字段2
            ,cai_remark3 -- 预留字段3
            ,cai_closedate -- 账户解挂日期
            ,cai_opendate -- 核心开户时间
            ,cai_annualenddate -- 账号年检到期日
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cai_cstno -- 企业客户号(ecif号)
    ,o.cai_ctftype -- 企业证件类型
    ,o.cai_ctfno -- 企业证件号
    ,o.cai_userno -- 录入操作员id(网银顺序号)
    ,o.cai_useralias -- 录入操作员别名(登录名)
    ,o.cai_accno -- 卡号/账号
    ,o.cai_acctype -- 账号类型（21-单位结算卡；类型可以扩展）
    ,o.cai_accname -- 户名
    ,o.cai_alias -- 账户别名
    ,o.cai_crflag -- 钞汇标志(c--钞;r--汇)
    ,o.cai_crytype -- 币种（cry人民币）
    ,o.cai_branchno -- 账户开户机构
    ,o.cai_state -- 状态(0：正常;1：网银删除;2：冻结;3：暂停)
    ,o.cai_signflag -- 账户签约标志（0：已签约；1：未签约）预留
    ,o.cai_signway -- 账户加挂方式（0:柜台签约1:交易银行pc签约2:交易银行app签约3:支付签约）
    ,o.cai_hide -- 是否隐藏(0：显示；1：隐藏；)
    ,o.cai_right -- 账户权限，8位，1-开通，0-未开通。第1位：单位结算卡,其他预留传0
    ,o.cai_sourcesys -- 来源系统(1:核心；1:电子账户系统)
    ,o.cai_firsttime -- 首次绑定时间
    ,o.cai_updatetime -- 更新时间
    ,o.cai_usetime -- 最近使用时间(从未使用则为注册时间，格式为yyyymmddhhmiss)
    ,o.cai_remark1 -- 预留字段1
    ,o.cai_remark2 -- 预留字段2
    ,o.cai_remark3 -- 预留字段3
    ,o.cai_closedate -- 账户解挂日期
    ,o.cai_opendate -- 核心开户时间
    ,o.cai_annualenddate -- 账号年检到期日
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.tbps_cpr_acc_inf_bk o
    left join ${iol_schema}.tbps_cpr_acc_inf_op n
        on
            o.cai_cstno = n.cai_cstno
            and o.cai_accno = n.cai_accno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tbps_cpr_acc_inf_cl d
        on
            o.cai_cstno = d.cai_cstno
            and o.cai_accno = d.cai_accno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.tbps_cpr_acc_inf;

-- 4.2 exchange partition
alter table ${iol_schema}.tbps_cpr_acc_inf exchange partition p_19000101 with table ${iol_schema}.tbps_cpr_acc_inf_cl;
alter table ${iol_schema}.tbps_cpr_acc_inf exchange partition p_20991231 with table ${iol_schema}.tbps_cpr_acc_inf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tbps_cpr_acc_inf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tbps_cpr_acc_inf_op purge;
drop table ${iol_schema}.tbps_cpr_acc_inf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tbps_cpr_acc_inf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tbps_cpr_acc_inf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
