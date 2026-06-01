/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_gl_detail
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
create table ${iol_schema}.iers_gl_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_gl_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_gl_detail_op purge;
drop table ${iol_schema}.iers_gl_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_gl_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_gl_detail where 0=1;

create table ${iol_schema}.iers_gl_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_gl_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_gl_detail_cl(
            accountcode -- 账簿编号
            ,adjustperiod -- 调整期间
            ,assid -- 辅助核算
            ,bankaccount -- 银行帐户
            ,billtype -- 票据类型
            ,busireconno -- 业务系统协同号
            ,checkdate -- 票据日期
            ,checkno -- 票据编码
            ,checkstyle -- 结算方式
            ,contrastflag -- 对账标志
            ,convertflag -- 是否折算
            ,creditamount -- 原币贷方金额
            ,creditquantity -- 贷方数量
            ,debitamount -- 原币借方金额
            ,debitquantity -- 借方数量
            ,detailindex -- 分录号
            ,direction -- 发生额方向
            ,discardflagv -- 作废标志
            ,dr -- 删除标志
            ,errmessage -- 错误信息
            ,errmessage2 -- 自定义
            ,errmessageh -- 标错的历史信息
            ,excrate1 -- 汇率1
            ,excrate2 -- 汇率2
            ,excrate3 -- 集团汇率
            ,excrate4 -- 全局汇率
            ,explanation -- 摘要
            ,fraccreditamount -- 辅币贷发生额
            ,fracdebitamount -- 辅币借发生额
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
            ,globalcreditamount -- 全局本币贷方金额
            ,globaldebitamount -- 全局本币借方金额
            ,groupcreditamount -- 集团本币贷方金额
            ,groupdebitamount -- 集团本币借方金额
            ,innerbusdate -- 自定义
            ,innerbusno -- 自定义
            ,isdifflag -- 是否差异凭证
            ,localcreditamount -- 组织本币贷方金额
            ,localdebitamount -- 组织本币借方金额
            ,modifyflag -- 修改标志
            ,netbankflag -- 网银对账标识码
            ,nov -- 凭证编码
            ,oppositesubj -- 对方科目
            ,periodv -- 期间
            ,pk_accasoa -- 科目
            ,pk_accchart -- 科目表主键
            ,pk_account -- 自定义
            ,pk_accountingbook -- 财务核算账簿
            ,pk_currtype -- 币种
            ,pk_detail -- 分录标识
            ,pk_group -- 所属集团
            ,pk_innerorg -- 自定义
            ,pk_innersob -- 自定义
            ,pk_managerv -- 记账人
            ,pk_offerdetail -- 被冲销的分录
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_othercorp -- 自定义
            ,pk_otherorgbook -- 自定义
            ,pk_preparedv -- 自定义
            ,pk_setofbook -- 账簿类型
            ,pk_sourcepk -- 折算来源
            ,pk_systemv -- 制单系统
            ,pk_unit -- 业务单元
            ,pk_unit_v -- 业务单元版本
            ,pk_voucher -- 凭证主键
            ,pk_vouchertypev -- 凭证类别
            ,prepareddatev -- 制单日期
            ,price -- 单价
            ,recieptclass -- 单据处理类
            ,signdatev -- 签字日期
            ,tempsaveflag -- 自定义
            ,ts -- 时间戳
            ,unitname -- 业务单元名称
            ,verifydate -- 核销日期
            ,verifyno -- 核销号
            ,voucherkindv -- 凭证类型
            ,yearv -- 年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_gl_detail_op(
            accountcode -- 账簿编号
            ,adjustperiod -- 调整期间
            ,assid -- 辅助核算
            ,bankaccount -- 银行帐户
            ,billtype -- 票据类型
            ,busireconno -- 业务系统协同号
            ,checkdate -- 票据日期
            ,checkno -- 票据编码
            ,checkstyle -- 结算方式
            ,contrastflag -- 对账标志
            ,convertflag -- 是否折算
            ,creditamount -- 原币贷方金额
            ,creditquantity -- 贷方数量
            ,debitamount -- 原币借方金额
            ,debitquantity -- 借方数量
            ,detailindex -- 分录号
            ,direction -- 发生额方向
            ,discardflagv -- 作废标志
            ,dr -- 删除标志
            ,errmessage -- 错误信息
            ,errmessage2 -- 自定义
            ,errmessageh -- 标错的历史信息
            ,excrate1 -- 汇率1
            ,excrate2 -- 汇率2
            ,excrate3 -- 集团汇率
            ,excrate4 -- 全局汇率
            ,explanation -- 摘要
            ,fraccreditamount -- 辅币贷发生额
            ,fracdebitamount -- 辅币借发生额
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
            ,globalcreditamount -- 全局本币贷方金额
            ,globaldebitamount -- 全局本币借方金额
            ,groupcreditamount -- 集团本币贷方金额
            ,groupdebitamount -- 集团本币借方金额
            ,innerbusdate -- 自定义
            ,innerbusno -- 自定义
            ,isdifflag -- 是否差异凭证
            ,localcreditamount -- 组织本币贷方金额
            ,localdebitamount -- 组织本币借方金额
            ,modifyflag -- 修改标志
            ,netbankflag -- 网银对账标识码
            ,nov -- 凭证编码
            ,oppositesubj -- 对方科目
            ,periodv -- 期间
            ,pk_accasoa -- 科目
            ,pk_accchart -- 科目表主键
            ,pk_account -- 自定义
            ,pk_accountingbook -- 财务核算账簿
            ,pk_currtype -- 币种
            ,pk_detail -- 分录标识
            ,pk_group -- 所属集团
            ,pk_innerorg -- 自定义
            ,pk_innersob -- 自定义
            ,pk_managerv -- 记账人
            ,pk_offerdetail -- 被冲销的分录
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_othercorp -- 自定义
            ,pk_otherorgbook -- 自定义
            ,pk_preparedv -- 自定义
            ,pk_setofbook -- 账簿类型
            ,pk_sourcepk -- 折算来源
            ,pk_systemv -- 制单系统
            ,pk_unit -- 业务单元
            ,pk_unit_v -- 业务单元版本
            ,pk_voucher -- 凭证主键
            ,pk_vouchertypev -- 凭证类别
            ,prepareddatev -- 制单日期
            ,price -- 单价
            ,recieptclass -- 单据处理类
            ,signdatev -- 签字日期
            ,tempsaveflag -- 自定义
            ,ts -- 时间戳
            ,unitname -- 业务单元名称
            ,verifydate -- 核销日期
            ,verifyno -- 核销号
            ,voucherkindv -- 凭证类型
            ,yearv -- 年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.accountcode, o.accountcode) as accountcode -- 账簿编号
    ,nvl(n.adjustperiod, o.adjustperiod) as adjustperiod -- 调整期间
    ,nvl(n.assid, o.assid) as assid -- 辅助核算
    ,nvl(n.bankaccount, o.bankaccount) as bankaccount -- 银行帐户
    ,nvl(n.billtype, o.billtype) as billtype -- 票据类型
    ,nvl(n.busireconno, o.busireconno) as busireconno -- 业务系统协同号
    ,nvl(n.checkdate, o.checkdate) as checkdate -- 票据日期
    ,nvl(n.checkno, o.checkno) as checkno -- 票据编码
    ,nvl(n.checkstyle, o.checkstyle) as checkstyle -- 结算方式
    ,nvl(n.contrastflag, o.contrastflag) as contrastflag -- 对账标志
    ,nvl(n.convertflag, o.convertflag) as convertflag -- 是否折算
    ,nvl(n.creditamount, o.creditamount) as creditamount -- 原币贷方金额
    ,nvl(n.creditquantity, o.creditquantity) as creditquantity -- 贷方数量
    ,nvl(n.debitamount, o.debitamount) as debitamount -- 原币借方金额
    ,nvl(n.debitquantity, o.debitquantity) as debitquantity -- 借方数量
    ,nvl(n.detailindex, o.detailindex) as detailindex -- 分录号
    ,nvl(n.direction, o.direction) as direction -- 发生额方向
    ,nvl(n.discardflagv, o.discardflagv) as discardflagv -- 作废标志
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.errmessage, o.errmessage) as errmessage -- 错误信息
    ,nvl(n.errmessage2, o.errmessage2) as errmessage2 -- 自定义
    ,nvl(n.errmessageh, o.errmessageh) as errmessageh -- 标错的历史信息
    ,nvl(n.excrate1, o.excrate1) as excrate1 -- 汇率1
    ,nvl(n.excrate2, o.excrate2) as excrate2 -- 汇率2
    ,nvl(n.excrate3, o.excrate3) as excrate3 -- 集团汇率
    ,nvl(n.excrate4, o.excrate4) as excrate4 -- 全局汇率
    ,nvl(n.explanation, o.explanation) as explanation -- 摘要
    ,nvl(n.fraccreditamount, o.fraccreditamount) as fraccreditamount -- 辅币贷发生额
    ,nvl(n.fracdebitamount, o.fracdebitamount) as fracdebitamount -- 辅币借发生额
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
    ,nvl(n.globalcreditamount, o.globalcreditamount) as globalcreditamount -- 全局本币贷方金额
    ,nvl(n.globaldebitamount, o.globaldebitamount) as globaldebitamount -- 全局本币借方金额
    ,nvl(n.groupcreditamount, o.groupcreditamount) as groupcreditamount -- 集团本币贷方金额
    ,nvl(n.groupdebitamount, o.groupdebitamount) as groupdebitamount -- 集团本币借方金额
    ,nvl(n.innerbusdate, o.innerbusdate) as innerbusdate -- 自定义
    ,nvl(n.innerbusno, o.innerbusno) as innerbusno -- 自定义
    ,nvl(n.isdifflag, o.isdifflag) as isdifflag -- 是否差异凭证
    ,nvl(n.localcreditamount, o.localcreditamount) as localcreditamount -- 组织本币贷方金额
    ,nvl(n.localdebitamount, o.localdebitamount) as localdebitamount -- 组织本币借方金额
    ,nvl(n.modifyflag, o.modifyflag) as modifyflag -- 修改标志
    ,nvl(n.netbankflag, o.netbankflag) as netbankflag -- 网银对账标识码
    ,nvl(n.nov, o.nov) as nov -- 凭证编码
    ,nvl(n.oppositesubj, o.oppositesubj) as oppositesubj -- 对方科目
    ,nvl(n.periodv, o.periodv) as periodv -- 期间
    ,nvl(n.pk_accasoa, o.pk_accasoa) as pk_accasoa -- 科目
    ,nvl(n.pk_accchart, o.pk_accchart) as pk_accchart -- 科目表主键
    ,nvl(n.pk_account, o.pk_account) as pk_account -- 自定义
    ,nvl(n.pk_accountingbook, o.pk_accountingbook) as pk_accountingbook -- 财务核算账簿
    ,nvl(n.pk_currtype, o.pk_currtype) as pk_currtype -- 币种
    ,nvl(n.pk_detail, o.pk_detail) as pk_detail -- 分录标识
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 所属集团
    ,nvl(n.pk_innerorg, o.pk_innerorg) as pk_innerorg -- 自定义
    ,nvl(n.pk_innersob, o.pk_innersob) as pk_innersob -- 自定义
    ,nvl(n.pk_managerv, o.pk_managerv) as pk_managerv -- 记账人
    ,nvl(n.pk_offerdetail, o.pk_offerdetail) as pk_offerdetail -- 被冲销的分录
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 财务组织
    ,nvl(n.pk_org_v, o.pk_org_v) as pk_org_v -- 财务组织版本
    ,nvl(n.pk_othercorp, o.pk_othercorp) as pk_othercorp -- 自定义
    ,nvl(n.pk_otherorgbook, o.pk_otherorgbook) as pk_otherorgbook -- 自定义
    ,nvl(n.pk_preparedv, o.pk_preparedv) as pk_preparedv -- 自定义
    ,nvl(n.pk_setofbook, o.pk_setofbook) as pk_setofbook -- 账簿类型
    ,nvl(n.pk_sourcepk, o.pk_sourcepk) as pk_sourcepk -- 折算来源
    ,nvl(n.pk_systemv, o.pk_systemv) as pk_systemv -- 制单系统
    ,nvl(n.pk_unit, o.pk_unit) as pk_unit -- 业务单元
    ,nvl(n.pk_unit_v, o.pk_unit_v) as pk_unit_v -- 业务单元版本
    ,nvl(n.pk_voucher, o.pk_voucher) as pk_voucher -- 凭证主键
    ,nvl(n.pk_vouchertypev, o.pk_vouchertypev) as pk_vouchertypev -- 凭证类别
    ,nvl(n.prepareddatev, o.prepareddatev) as prepareddatev -- 制单日期
    ,nvl(n.price, o.price) as price -- 单价
    ,nvl(n.recieptclass, o.recieptclass) as recieptclass -- 单据处理类
    ,nvl(n.signdatev, o.signdatev) as signdatev -- 签字日期
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 自定义
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.unitname, o.unitname) as unitname -- 业务单元名称
    ,nvl(n.verifydate, o.verifydate) as verifydate -- 核销日期
    ,nvl(n.verifyno, o.verifyno) as verifyno -- 核销号
    ,nvl(n.voucherkindv, o.voucherkindv) as voucherkindv -- 凭证类型
    ,nvl(n.yearv, o.yearv) as yearv -- 年度
    ,case when
            n.pk_detail is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_detail is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_detail is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_gl_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_gl_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_detail = n.pk_detail
where (
        o.pk_detail is null
    )
    or (
        n.pk_detail is null
    )
    or (
        o.accountcode <> n.accountcode
        or o.adjustperiod <> n.adjustperiod
        or o.assid <> n.assid
        or o.bankaccount <> n.bankaccount
        or o.billtype <> n.billtype
        or o.busireconno <> n.busireconno
        or o.checkdate <> n.checkdate
        or o.checkno <> n.checkno
        or o.checkstyle <> n.checkstyle
        or o.contrastflag <> n.contrastflag
        or o.convertflag <> n.convertflag
        or o.creditamount <> n.creditamount
        or o.creditquantity <> n.creditquantity
        or o.debitamount <> n.debitamount
        or o.debitquantity <> n.debitquantity
        or o.detailindex <> n.detailindex
        or o.direction <> n.direction
        or o.discardflagv <> n.discardflagv
        or o.dr <> n.dr
        or o.errmessage <> n.errmessage
        or o.errmessage2 <> n.errmessage2
        or o.errmessageh <> n.errmessageh
        or o.excrate1 <> n.excrate1
        or o.excrate2 <> n.excrate2
        or o.excrate3 <> n.excrate3
        or o.excrate4 <> n.excrate4
        or o.explanation <> n.explanation
        or o.fraccreditamount <> n.fraccreditamount
        or o.fracdebitamount <> n.fracdebitamount
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
        or o.globalcreditamount <> n.globalcreditamount
        or o.globaldebitamount <> n.globaldebitamount
        or o.groupcreditamount <> n.groupcreditamount
        or o.groupdebitamount <> n.groupdebitamount
        or o.innerbusdate <> n.innerbusdate
        or o.innerbusno <> n.innerbusno
        or o.isdifflag <> n.isdifflag
        or o.localcreditamount <> n.localcreditamount
        or o.localdebitamount <> n.localdebitamount
        or o.modifyflag <> n.modifyflag
        or o.netbankflag <> n.netbankflag
        or o.nov <> n.nov
        or o.oppositesubj <> n.oppositesubj
        or o.periodv <> n.periodv
        or o.pk_accasoa <> n.pk_accasoa
        or o.pk_accchart <> n.pk_accchart
        or o.pk_account <> n.pk_account
        or o.pk_accountingbook <> n.pk_accountingbook
        or o.pk_currtype <> n.pk_currtype
        or o.pk_group <> n.pk_group
        or o.pk_innerorg <> n.pk_innerorg
        or o.pk_innersob <> n.pk_innersob
        or o.pk_managerv <> n.pk_managerv
        or o.pk_offerdetail <> n.pk_offerdetail
        or o.pk_org <> n.pk_org
        or o.pk_org_v <> n.pk_org_v
        or o.pk_othercorp <> n.pk_othercorp
        or o.pk_otherorgbook <> n.pk_otherorgbook
        or o.pk_preparedv <> n.pk_preparedv
        or o.pk_setofbook <> n.pk_setofbook
        or o.pk_sourcepk <> n.pk_sourcepk
        or o.pk_systemv <> n.pk_systemv
        or o.pk_unit <> n.pk_unit
        or o.pk_unit_v <> n.pk_unit_v
        or o.pk_voucher <> n.pk_voucher
        or o.pk_vouchertypev <> n.pk_vouchertypev
        or o.prepareddatev <> n.prepareddatev
        or o.price <> n.price
        or o.recieptclass <> n.recieptclass
        or o.signdatev <> n.signdatev
        or o.tempsaveflag <> n.tempsaveflag
        or o.ts <> n.ts
        or o.unitname <> n.unitname
        or o.verifydate <> n.verifydate
        or o.verifyno <> n.verifyno
        or o.voucherkindv <> n.voucherkindv
        or o.yearv <> n.yearv
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_gl_detail_cl(
            accountcode -- 账簿编号
            ,adjustperiod -- 调整期间
            ,assid -- 辅助核算
            ,bankaccount -- 银行帐户
            ,billtype -- 票据类型
            ,busireconno -- 业务系统协同号
            ,checkdate -- 票据日期
            ,checkno -- 票据编码
            ,checkstyle -- 结算方式
            ,contrastflag -- 对账标志
            ,convertflag -- 是否折算
            ,creditamount -- 原币贷方金额
            ,creditquantity -- 贷方数量
            ,debitamount -- 原币借方金额
            ,debitquantity -- 借方数量
            ,detailindex -- 分录号
            ,direction -- 发生额方向
            ,discardflagv -- 作废标志
            ,dr -- 删除标志
            ,errmessage -- 错误信息
            ,errmessage2 -- 自定义
            ,errmessageh -- 标错的历史信息
            ,excrate1 -- 汇率1
            ,excrate2 -- 汇率2
            ,excrate3 -- 集团汇率
            ,excrate4 -- 全局汇率
            ,explanation -- 摘要
            ,fraccreditamount -- 辅币贷发生额
            ,fracdebitamount -- 辅币借发生额
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
            ,globalcreditamount -- 全局本币贷方金额
            ,globaldebitamount -- 全局本币借方金额
            ,groupcreditamount -- 集团本币贷方金额
            ,groupdebitamount -- 集团本币借方金额
            ,innerbusdate -- 自定义
            ,innerbusno -- 自定义
            ,isdifflag -- 是否差异凭证
            ,localcreditamount -- 组织本币贷方金额
            ,localdebitamount -- 组织本币借方金额
            ,modifyflag -- 修改标志
            ,netbankflag -- 网银对账标识码
            ,nov -- 凭证编码
            ,oppositesubj -- 对方科目
            ,periodv -- 期间
            ,pk_accasoa -- 科目
            ,pk_accchart -- 科目表主键
            ,pk_account -- 自定义
            ,pk_accountingbook -- 财务核算账簿
            ,pk_currtype -- 币种
            ,pk_detail -- 分录标识
            ,pk_group -- 所属集团
            ,pk_innerorg -- 自定义
            ,pk_innersob -- 自定义
            ,pk_managerv -- 记账人
            ,pk_offerdetail -- 被冲销的分录
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_othercorp -- 自定义
            ,pk_otherorgbook -- 自定义
            ,pk_preparedv -- 自定义
            ,pk_setofbook -- 账簿类型
            ,pk_sourcepk -- 折算来源
            ,pk_systemv -- 制单系统
            ,pk_unit -- 业务单元
            ,pk_unit_v -- 业务单元版本
            ,pk_voucher -- 凭证主键
            ,pk_vouchertypev -- 凭证类别
            ,prepareddatev -- 制单日期
            ,price -- 单价
            ,recieptclass -- 单据处理类
            ,signdatev -- 签字日期
            ,tempsaveflag -- 自定义
            ,ts -- 时间戳
            ,unitname -- 业务单元名称
            ,verifydate -- 核销日期
            ,verifyno -- 核销号
            ,voucherkindv -- 凭证类型
            ,yearv -- 年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_gl_detail_op(
            accountcode -- 账簿编号
            ,adjustperiod -- 调整期间
            ,assid -- 辅助核算
            ,bankaccount -- 银行帐户
            ,billtype -- 票据类型
            ,busireconno -- 业务系统协同号
            ,checkdate -- 票据日期
            ,checkno -- 票据编码
            ,checkstyle -- 结算方式
            ,contrastflag -- 对账标志
            ,convertflag -- 是否折算
            ,creditamount -- 原币贷方金额
            ,creditquantity -- 贷方数量
            ,debitamount -- 原币借方金额
            ,debitquantity -- 借方数量
            ,detailindex -- 分录号
            ,direction -- 发生额方向
            ,discardflagv -- 作废标志
            ,dr -- 删除标志
            ,errmessage -- 错误信息
            ,errmessage2 -- 自定义
            ,errmessageh -- 标错的历史信息
            ,excrate1 -- 汇率1
            ,excrate2 -- 汇率2
            ,excrate3 -- 集团汇率
            ,excrate4 -- 全局汇率
            ,explanation -- 摘要
            ,fraccreditamount -- 辅币贷发生额
            ,fracdebitamount -- 辅币借发生额
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
            ,globalcreditamount -- 全局本币贷方金额
            ,globaldebitamount -- 全局本币借方金额
            ,groupcreditamount -- 集团本币贷方金额
            ,groupdebitamount -- 集团本币借方金额
            ,innerbusdate -- 自定义
            ,innerbusno -- 自定义
            ,isdifflag -- 是否差异凭证
            ,localcreditamount -- 组织本币贷方金额
            ,localdebitamount -- 组织本币借方金额
            ,modifyflag -- 修改标志
            ,netbankflag -- 网银对账标识码
            ,nov -- 凭证编码
            ,oppositesubj -- 对方科目
            ,periodv -- 期间
            ,pk_accasoa -- 科目
            ,pk_accchart -- 科目表主键
            ,pk_account -- 自定义
            ,pk_accountingbook -- 财务核算账簿
            ,pk_currtype -- 币种
            ,pk_detail -- 分录标识
            ,pk_group -- 所属集团
            ,pk_innerorg -- 自定义
            ,pk_innersob -- 自定义
            ,pk_managerv -- 记账人
            ,pk_offerdetail -- 被冲销的分录
            ,pk_org -- 财务组织
            ,pk_org_v -- 财务组织版本
            ,pk_othercorp -- 自定义
            ,pk_otherorgbook -- 自定义
            ,pk_preparedv -- 自定义
            ,pk_setofbook -- 账簿类型
            ,pk_sourcepk -- 折算来源
            ,pk_systemv -- 制单系统
            ,pk_unit -- 业务单元
            ,pk_unit_v -- 业务单元版本
            ,pk_voucher -- 凭证主键
            ,pk_vouchertypev -- 凭证类别
            ,prepareddatev -- 制单日期
            ,price -- 单价
            ,recieptclass -- 单据处理类
            ,signdatev -- 签字日期
            ,tempsaveflag -- 自定义
            ,ts -- 时间戳
            ,unitname -- 业务单元名称
            ,verifydate -- 核销日期
            ,verifyno -- 核销号
            ,voucherkindv -- 凭证类型
            ,yearv -- 年度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.accountcode -- 账簿编号
    ,o.adjustperiod -- 调整期间
    ,o.assid -- 辅助核算
    ,o.bankaccount -- 银行帐户
    ,o.billtype -- 票据类型
    ,o.busireconno -- 业务系统协同号
    ,o.checkdate -- 票据日期
    ,o.checkno -- 票据编码
    ,o.checkstyle -- 结算方式
    ,o.contrastflag -- 对账标志
    ,o.convertflag -- 是否折算
    ,o.creditamount -- 原币贷方金额
    ,o.creditquantity -- 贷方数量
    ,o.debitamount -- 原币借方金额
    ,o.debitquantity -- 借方数量
    ,o.detailindex -- 分录号
    ,o.direction -- 发生额方向
    ,o.discardflagv -- 作废标志
    ,o.dr -- 删除标志
    ,o.errmessage -- 错误信息
    ,o.errmessage2 -- 自定义
    ,o.errmessageh -- 标错的历史信息
    ,o.excrate1 -- 汇率1
    ,o.excrate2 -- 汇率2
    ,o.excrate3 -- 集团汇率
    ,o.excrate4 -- 全局汇率
    ,o.explanation -- 摘要
    ,o.fraccreditamount -- 辅币贷发生额
    ,o.fracdebitamount -- 辅币借发生额
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
    ,o.globalcreditamount -- 全局本币贷方金额
    ,o.globaldebitamount -- 全局本币借方金额
    ,o.groupcreditamount -- 集团本币贷方金额
    ,o.groupdebitamount -- 集团本币借方金额
    ,o.innerbusdate -- 自定义
    ,o.innerbusno -- 自定义
    ,o.isdifflag -- 是否差异凭证
    ,o.localcreditamount -- 组织本币贷方金额
    ,o.localdebitamount -- 组织本币借方金额
    ,o.modifyflag -- 修改标志
    ,o.netbankflag -- 网银对账标识码
    ,o.nov -- 凭证编码
    ,o.oppositesubj -- 对方科目
    ,o.periodv -- 期间
    ,o.pk_accasoa -- 科目
    ,o.pk_accchart -- 科目表主键
    ,o.pk_account -- 自定义
    ,o.pk_accountingbook -- 财务核算账簿
    ,o.pk_currtype -- 币种
    ,o.pk_detail -- 分录标识
    ,o.pk_group -- 所属集团
    ,o.pk_innerorg -- 自定义
    ,o.pk_innersob -- 自定义
    ,o.pk_managerv -- 记账人
    ,o.pk_offerdetail -- 被冲销的分录
    ,o.pk_org -- 财务组织
    ,o.pk_org_v -- 财务组织版本
    ,o.pk_othercorp -- 自定义
    ,o.pk_otherorgbook -- 自定义
    ,o.pk_preparedv -- 自定义
    ,o.pk_setofbook -- 账簿类型
    ,o.pk_sourcepk -- 折算来源
    ,o.pk_systemv -- 制单系统
    ,o.pk_unit -- 业务单元
    ,o.pk_unit_v -- 业务单元版本
    ,o.pk_voucher -- 凭证主键
    ,o.pk_vouchertypev -- 凭证类别
    ,o.prepareddatev -- 制单日期
    ,o.price -- 单价
    ,o.recieptclass -- 单据处理类
    ,o.signdatev -- 签字日期
    ,o.tempsaveflag -- 自定义
    ,o.ts -- 时间戳
    ,o.unitname -- 业务单元名称
    ,o.verifydate -- 核销日期
    ,o.verifyno -- 核销号
    ,o.voucherkindv -- 凭证类型
    ,o.yearv -- 年度
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
from ${iol_schema}.iers_gl_detail_bk o
    left join ${iol_schema}.iers_gl_detail_op n
        on
            o.pk_detail = n.pk_detail
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_gl_detail_cl d
        on
            o.pk_detail = d.pk_detail
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_gl_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_gl_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_gl_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_gl_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_gl_detail exchange partition p_${batch_date} with table ${iol_schema}.iers_gl_detail_cl;
alter table ${iol_schema}.iers_gl_detail exchange partition p_20991231 with table ${iol_schema}.iers_gl_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_gl_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_gl_detail_op purge;
drop table ${iol_schema}.iers_gl_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_gl_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_gl_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
