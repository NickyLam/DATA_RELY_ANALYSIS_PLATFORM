/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_gl_voucher
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
create table ${iol_schema}.iers_gl_voucher_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_gl_voucher
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_gl_voucher_op purge;
drop table ${iol_schema}.iers_gl_voucher_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_voucher_op nologging
for exchange with table
${iol_schema}.iers_gl_voucher;

create table ${iol_schema}.iers_gl_voucher_cl nologging
for exchange with table
${iol_schema}.iers_gl_voucher;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_gl_voucher_cl(
            addclass -- 增加接口类
            ,adjustperiod -- 调整期间
            ,approver -- 
            ,attachment -- 附单据数
            ,billmaker -- 
            ,checkeddate -- 审核日期
            ,contrastflag -- 
            ,convertflag -- 折算凭证
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,deleteclass -- 删除接口类
            ,detailmodflag -- 分录增删标志
            ,discardflag -- 作废标志
            ,dr -- 删除标志
            ,errmessage -- 错误信息
            ,errmessageh -- 历史错误信息
            ,explanation -- 摘要
            ,free1 -- 预留字段1
            ,free10 -- 预留字段10
            ,free2 -- 预留字段2
            ,free3 -- 预留字段3
            ,free4 -- 预留字段4
            ,free5 -- 预留字段5
            ,free6 -- 预留字段6
            ,free7 -- 预留字段7
            ,free8 -- 预留字段8
            ,free9 -- 预留字段9
            ,isdifflag -- 差异凭证
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,modifyclass -- 修改接口类
            ,modifyflag -- 修改标志
            ,num -- 凭证编码
            ,offervoucher -- 冲销凭证
            ,period -- 会计期间
            ,pk_accountingbook -- 核算账簿
            ,pk_casher -- 出纳
            ,pk_checked -- 审核人
            ,pk_group -- 所属集团
            ,pk_manager -- 记账人
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_prepared -- 制单人
            ,pk_setofbook -- 账簿类型
            ,pk_sourcepk -- 折算来源凭证
            ,pk_system -- 制单系统
            ,pk_voucher -- 凭证主键
            ,pk_vouchertype -- 凭证类别
            ,preaccountflag -- 提前关账科目
            ,prepareddate -- 制单日期
            ,signdate -- 签字日期
            ,signflag -- 签字标志
            ,tallydate -- 记账日期
            ,tempsaveflag -- 暂存标志
            ,totalcredit -- 贷方合计
            ,totalcreditglobal -- 全局贷方合计
            ,totalcreditgroup -- 集团贷方合计
            ,totaldebit -- 借方合计
            ,totaldebitglobal -- 全局借方合计
            ,totaldebitgroup -- 集团借方合计
            ,ts -- 时间戳
            ,voucherkind -- 凭证类型
            ,year -- 会计年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_gl_voucher_op(
            addclass -- 增加接口类
            ,adjustperiod -- 调整期间
            ,approver -- 
            ,attachment -- 附单据数
            ,billmaker -- 
            ,checkeddate -- 审核日期
            ,contrastflag -- 
            ,convertflag -- 折算凭证
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,deleteclass -- 删除接口类
            ,detailmodflag -- 分录增删标志
            ,discardflag -- 作废标志
            ,dr -- 删除标志
            ,errmessage -- 错误信息
            ,errmessageh -- 历史错误信息
            ,explanation -- 摘要
            ,free1 -- 预留字段1
            ,free10 -- 预留字段10
            ,free2 -- 预留字段2
            ,free3 -- 预留字段3
            ,free4 -- 预留字段4
            ,free5 -- 预留字段5
            ,free6 -- 预留字段6
            ,free7 -- 预留字段7
            ,free8 -- 预留字段8
            ,free9 -- 预留字段9
            ,isdifflag -- 差异凭证
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,modifyclass -- 修改接口类
            ,modifyflag -- 修改标志
            ,num -- 凭证编码
            ,offervoucher -- 冲销凭证
            ,period -- 会计期间
            ,pk_accountingbook -- 核算账簿
            ,pk_casher -- 出纳
            ,pk_checked -- 审核人
            ,pk_group -- 所属集团
            ,pk_manager -- 记账人
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_prepared -- 制单人
            ,pk_setofbook -- 账簿类型
            ,pk_sourcepk -- 折算来源凭证
            ,pk_system -- 制单系统
            ,pk_voucher -- 凭证主键
            ,pk_vouchertype -- 凭证类别
            ,preaccountflag -- 提前关账科目
            ,prepareddate -- 制单日期
            ,signdate -- 签字日期
            ,signflag -- 签字标志
            ,tallydate -- 记账日期
            ,tempsaveflag -- 暂存标志
            ,totalcredit -- 贷方合计
            ,totalcreditglobal -- 全局贷方合计
            ,totalcreditgroup -- 集团贷方合计
            ,totaldebit -- 借方合计
            ,totaldebitglobal -- 全局借方合计
            ,totaldebitgroup -- 集团借方合计
            ,ts -- 时间戳
            ,voucherkind -- 凭证类型
            ,year -- 会计年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.addclass, o.addclass) as addclass -- 增加接口类
    ,nvl(n.adjustperiod, o.adjustperiod) as adjustperiod -- 调整期间
    ,nvl(n.approver, o.approver) as approver -- 
    ,nvl(n.attachment, o.attachment) as attachment -- 附单据数
    ,nvl(n.billmaker, o.billmaker) as billmaker -- 
    ,nvl(n.checkeddate, o.checkeddate) as checkeddate -- 审核日期
    ,nvl(n.contrastflag, o.contrastflag) as contrastflag -- 
    ,nvl(n.convertflag, o.convertflag) as convertflag -- 折算凭证
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.deleteclass, o.deleteclass) as deleteclass -- 删除接口类
    ,nvl(n.detailmodflag, o.detailmodflag) as detailmodflag -- 分录增删标志
    ,nvl(n.discardflag, o.discardflag) as discardflag -- 作废标志
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.errmessage, o.errmessage) as errmessage -- 错误信息
    ,nvl(n.errmessageh, o.errmessageh) as errmessageh -- 历史错误信息
    ,nvl(n.explanation, o.explanation) as explanation -- 摘要
    ,nvl(n.free1, o.free1) as free1 -- 预留字段1
    ,nvl(n.free10, o.free10) as free10 -- 预留字段10
    ,nvl(n.free2, o.free2) as free2 -- 预留字段2
    ,nvl(n.free3, o.free3) as free3 -- 预留字段3
    ,nvl(n.free4, o.free4) as free4 -- 预留字段4
    ,nvl(n.free5, o.free5) as free5 -- 预留字段5
    ,nvl(n.free6, o.free6) as free6 -- 预留字段6
    ,nvl(n.free7, o.free7) as free7 -- 预留字段7
    ,nvl(n.free8, o.free8) as free8 -- 预留字段8
    ,nvl(n.free9, o.free9) as free9 -- 预留字段9
    ,nvl(n.isdifflag, o.isdifflag) as isdifflag -- 差异凭证
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.modifyclass, o.modifyclass) as modifyclass -- 修改接口类
    ,nvl(n.modifyflag, o.modifyflag) as modifyflag -- 修改标志
    ,nvl(n.num, o.num) as num -- 凭证编码
    ,nvl(n.offervoucher, o.offervoucher) as offervoucher -- 冲销凭证
    ,nvl(n.period, o.period) as period -- 会计期间
    ,nvl(n.pk_accountingbook, o.pk_accountingbook) as pk_accountingbook -- 核算账簿
    ,nvl(n.pk_casher, o.pk_casher) as pk_casher -- 出纳
    ,nvl(n.pk_checked, o.pk_checked) as pk_checked -- 审核人
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_manager, o.pk_manager) as pk_manager -- 记账人
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 财务组织
    ,nvl(n.pk_org_v, o.pk_org_v) as pk_org_v -- 财务组织版本
    ,nvl(n.pk_prepared, o.pk_prepared) as pk_prepared -- 制单人
    ,nvl(n.pk_setofbook, o.pk_setofbook) as pk_setofbook -- 账簿类型
    ,nvl(n.pk_sourcepk, o.pk_sourcepk) as pk_sourcepk -- 折算来源凭证
    ,nvl(n.pk_system, o.pk_system) as pk_system -- 制单系统
    ,nvl(n.pk_voucher, o.pk_voucher) as pk_voucher -- 凭证主键
    ,nvl(n.pk_vouchertype, o.pk_vouchertype) as pk_vouchertype -- 凭证类别
    ,nvl(n.preaccountflag, o.preaccountflag) as preaccountflag -- 提前关账科目
    ,nvl(n.prepareddate, o.prepareddate) as prepareddate -- 制单日期
    ,nvl(n.signdate, o.signdate) as signdate -- 签字日期
    ,nvl(n.signflag, o.signflag) as signflag -- 签字标志
    ,nvl(n.tallydate, o.tallydate) as tallydate -- 记账日期
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标志
    ,nvl(n.totalcredit, o.totalcredit) as totalcredit -- 贷方合计
    ,nvl(n.totalcreditglobal, o.totalcreditglobal) as totalcreditglobal -- 全局贷方合计
    ,nvl(n.totalcreditgroup, o.totalcreditgroup) as totalcreditgroup -- 集团贷方合计
    ,nvl(n.totaldebit, o.totaldebit) as totaldebit -- 借方合计
    ,nvl(n.totaldebitglobal, o.totaldebitglobal) as totaldebitglobal -- 全局借方合计
    ,nvl(n.totaldebitgroup, o.totaldebitgroup) as totaldebitgroup -- 集团借方合计
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.voucherkind, o.voucherkind) as voucherkind -- 凭证类型
    ,nvl(n.year, o.year) as year -- 会计年度
    ,case when
            n.pk_voucher is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_voucher is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_voucher is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_gl_voucher_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_gl_voucher where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_voucher = n.pk_voucher
where (
        o.pk_voucher is null
    )
    or (
        n.pk_voucher is null
    )
    or (
        o.addclass <> n.addclass
        or o.adjustperiod <> n.adjustperiod
        or o.approver <> n.approver
        or o.attachment <> n.attachment
        or o.billmaker <> n.billmaker
        or o.checkeddate <> n.checkeddate
        or o.contrastflag <> n.contrastflag
        or o.convertflag <> n.convertflag
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.deleteclass <> n.deleteclass
        or o.detailmodflag <> n.detailmodflag
        or o.discardflag <> n.discardflag
        or o.dr <> n.dr
        or o.errmessage <> n.errmessage
        or o.errmessageh <> n.errmessageh
        or o.explanation <> n.explanation
        or o.free1 <> n.free1
        or o.free10 <> n.free10
        or o.free2 <> n.free2
        or o.free3 <> n.free3
        or o.free4 <> n.free4
        or o.free5 <> n.free5
        or o.free6 <> n.free6
        or o.free7 <> n.free7
        or o.free8 <> n.free8
        or o.free9 <> n.free9
        or o.isdifflag <> n.isdifflag
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.modifyclass <> n.modifyclass
        or o.modifyflag <> n.modifyflag
        or o.num <> n.num
        or o.offervoucher <> n.offervoucher
        or o.period <> n.period
        or o.pk_accountingbook <> n.pk_accountingbook
        or o.pk_casher <> n.pk_casher
        or o.pk_checked <> n.pk_checked
        or o.pk_group <> n.pk_group
        or o.pk_manager <> n.pk_manager
        or o.pk_org <> n.pk_org
        or o.pk_org_v <> n.pk_org_v
        or o.pk_prepared <> n.pk_prepared
        or o.pk_setofbook <> n.pk_setofbook
        or o.pk_sourcepk <> n.pk_sourcepk
        or o.pk_system <> n.pk_system
        or o.pk_vouchertype <> n.pk_vouchertype
        or o.preaccountflag <> n.preaccountflag
        or o.prepareddate <> n.prepareddate
        or o.signdate <> n.signdate
        or o.signflag <> n.signflag
        or o.tallydate <> n.tallydate
        or o.tempsaveflag <> n.tempsaveflag
        or o.totalcredit <> n.totalcredit
        or o.totalcreditglobal <> n.totalcreditglobal
        or o.totalcreditgroup <> n.totalcreditgroup
        or o.totaldebit <> n.totaldebit
        or o.totaldebitglobal <> n.totaldebitglobal
        or o.totaldebitgroup <> n.totaldebitgroup
        or o.ts <> n.ts
        or o.voucherkind <> n.voucherkind
        or o.year <> n.year
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_gl_voucher_cl(
            addclass -- 增加接口类
            ,adjustperiod -- 调整期间
            ,approver -- 
            ,attachment -- 附单据数
            ,billmaker -- 
            ,checkeddate -- 审核日期
            ,contrastflag -- 
            ,convertflag -- 折算凭证
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,deleteclass -- 删除接口类
            ,detailmodflag -- 分录增删标志
            ,discardflag -- 作废标志
            ,dr -- 删除标志
            ,errmessage -- 错误信息
            ,errmessageh -- 历史错误信息
            ,explanation -- 摘要
            ,free1 -- 预留字段1
            ,free10 -- 预留字段10
            ,free2 -- 预留字段2
            ,free3 -- 预留字段3
            ,free4 -- 预留字段4
            ,free5 -- 预留字段5
            ,free6 -- 预留字段6
            ,free7 -- 预留字段7
            ,free8 -- 预留字段8
            ,free9 -- 预留字段9
            ,isdifflag -- 差异凭证
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,modifyclass -- 修改接口类
            ,modifyflag -- 修改标志
            ,num -- 凭证编码
            ,offervoucher -- 冲销凭证
            ,period -- 会计期间
            ,pk_accountingbook -- 核算账簿
            ,pk_casher -- 出纳
            ,pk_checked -- 审核人
            ,pk_group -- 所属集团
            ,pk_manager -- 记账人
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_prepared -- 制单人
            ,pk_setofbook -- 账簿类型
            ,pk_sourcepk -- 折算来源凭证
            ,pk_system -- 制单系统
            ,pk_voucher -- 凭证主键
            ,pk_vouchertype -- 凭证类别
            ,preaccountflag -- 提前关账科目
            ,prepareddate -- 制单日期
            ,signdate -- 签字日期
            ,signflag -- 签字标志
            ,tallydate -- 记账日期
            ,tempsaveflag -- 暂存标志
            ,totalcredit -- 贷方合计
            ,totalcreditglobal -- 全局贷方合计
            ,totalcreditgroup -- 集团贷方合计
            ,totaldebit -- 借方合计
            ,totaldebitglobal -- 全局借方合计
            ,totaldebitgroup -- 集团借方合计
            ,ts -- 时间戳
            ,voucherkind -- 凭证类型
            ,year -- 会计年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_gl_voucher_op(
            addclass -- 增加接口类
            ,adjustperiod -- 调整期间
            ,approver -- 
            ,attachment -- 附单据数
            ,billmaker -- 
            ,checkeddate -- 审核日期
            ,contrastflag -- 
            ,convertflag -- 折算凭证
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,deleteclass -- 删除接口类
            ,detailmodflag -- 分录增删标志
            ,discardflag -- 作废标志
            ,dr -- 删除标志
            ,errmessage -- 错误信息
            ,errmessageh -- 历史错误信息
            ,explanation -- 摘要
            ,free1 -- 预留字段1
            ,free10 -- 预留字段10
            ,free2 -- 预留字段2
            ,free3 -- 预留字段3
            ,free4 -- 预留字段4
            ,free5 -- 预留字段5
            ,free6 -- 预留字段6
            ,free7 -- 预留字段7
            ,free8 -- 预留字段8
            ,free9 -- 预留字段9
            ,isdifflag -- 差异凭证
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,modifyclass -- 修改接口类
            ,modifyflag -- 修改标志
            ,num -- 凭证编码
            ,offervoucher -- 冲销凭证
            ,period -- 会计期间
            ,pk_accountingbook -- 核算账簿
            ,pk_casher -- 出纳
            ,pk_checked -- 审核人
            ,pk_group -- 所属集团
            ,pk_manager -- 记账人
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_prepared -- 制单人
            ,pk_setofbook -- 账簿类型
            ,pk_sourcepk -- 折算来源凭证
            ,pk_system -- 制单系统
            ,pk_voucher -- 凭证主键
            ,pk_vouchertype -- 凭证类别
            ,preaccountflag -- 提前关账科目
            ,prepareddate -- 制单日期
            ,signdate -- 签字日期
            ,signflag -- 签字标志
            ,tallydate -- 记账日期
            ,tempsaveflag -- 暂存标志
            ,totalcredit -- 贷方合计
            ,totalcreditglobal -- 全局贷方合计
            ,totalcreditgroup -- 集团贷方合计
            ,totaldebit -- 借方合计
            ,totaldebitglobal -- 全局借方合计
            ,totaldebitgroup -- 集团借方合计
            ,ts -- 时间戳
            ,voucherkind -- 凭证类型
            ,year -- 会计年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.addclass -- 增加接口类
    ,o.adjustperiod -- 调整期间
    ,o.approver -- 
    ,o.attachment -- 附单据数
    ,o.billmaker -- 
    ,o.checkeddate -- 审核日期
    ,o.contrastflag -- 
    ,o.convertflag -- 折算凭证
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.deleteclass -- 删除接口类
    ,o.detailmodflag -- 分录增删标志
    ,o.discardflag -- 作废标志
    ,o.dr -- 删除标志
    ,o.errmessage -- 错误信息
    ,o.errmessageh -- 历史错误信息
    ,o.explanation -- 摘要
    ,o.free1 -- 预留字段1
    ,o.free10 -- 预留字段10
    ,o.free2 -- 预留字段2
    ,o.free3 -- 预留字段3
    ,o.free4 -- 预留字段4
    ,o.free5 -- 预留字段5
    ,o.free6 -- 预留字段6
    ,o.free7 -- 预留字段7
    ,o.free8 -- 预留字段8
    ,o.free9 -- 预留字段9
    ,o.isdifflag -- 差异凭证
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.modifyclass -- 修改接口类
    ,o.modifyflag -- 修改标志
    ,o.num -- 凭证编码
    ,o.offervoucher -- 冲销凭证
    ,o.period -- 会计期间
    ,o.pk_accountingbook -- 核算账簿
    ,o.pk_casher -- 出纳
    ,o.pk_checked -- 审核人
    ,o.pk_group -- 所属集团
    ,o.pk_manager -- 记账人
    ,o.pk_org -- 财务组织
    ,o.pk_org_v -- 财务组织版本
    ,o.pk_prepared -- 制单人
    ,o.pk_setofbook -- 账簿类型
    ,o.pk_sourcepk -- 折算来源凭证
    ,o.pk_system -- 制单系统
    ,o.pk_voucher -- 凭证主键
    ,o.pk_vouchertype -- 凭证类别
    ,o.preaccountflag -- 提前关账科目
    ,o.prepareddate -- 制单日期
    ,o.signdate -- 签字日期
    ,o.signflag -- 签字标志
    ,o.tallydate -- 记账日期
    ,o.tempsaveflag -- 暂存标志
    ,o.totalcredit -- 贷方合计
    ,o.totalcreditglobal -- 全局贷方合计
    ,o.totalcreditgroup -- 集团贷方合计
    ,o.totaldebit -- 借方合计
    ,o.totaldebitglobal -- 全局借方合计
    ,o.totaldebitgroup -- 集团借方合计
    ,o.ts -- 时间戳
    ,o.voucherkind -- 凭证类型
    ,o.year -- 会计年度
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
from ${iol_schema}.iers_gl_voucher_bk o
    left join ${iol_schema}.iers_gl_voucher_op n
        on
            o.pk_voucher = n.pk_voucher
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_gl_voucher_cl d
        on
            o.pk_voucher = d.pk_voucher
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_gl_voucher;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_gl_voucher') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_gl_voucher drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_gl_voucher add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_gl_voucher exchange partition p_${batch_date} with table ${iol_schema}.iers_gl_voucher_cl;
alter table ${iol_schema}.iers_gl_voucher exchange partition p_20991231 with table ${iol_schema}.iers_gl_voucher_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_gl_voucher to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_gl_voucher_op purge;
drop table ${iol_schema}.iers_gl_voucher_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_gl_voucher_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_gl_voucher',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
