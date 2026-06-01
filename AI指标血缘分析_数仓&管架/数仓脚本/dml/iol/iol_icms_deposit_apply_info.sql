/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_deposit_apply_info
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
create table ${iol_schema}.icms_deposit_apply_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_deposit_apply_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_deposit_apply_info_op purge;
drop table ${iol_schema}.icms_deposit_apply_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_deposit_apply_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_deposit_apply_info where 0=1;

create table ${iol_schema}.icms_deposit_apply_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_deposit_apply_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_deposit_apply_info_cl(
            serialno -- 申请流水号
            ,remake -- 追加说明
            ,cusname -- 客户名称
            ,grteac -- 保证金帐号
            ,pigeonholedate -- 归档日期
            ,pdrifv -- 浮动值
            ,inputorgid -- 登记机构
            ,cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
            ,exchangedate -- 交易日期
            ,otrvbldn -- 表外记账方向
            ,crcycd -- 币种
            ,otrvacno -- 表外账号
            ,fxfltp -- 利率类型（核心crgtrt加）
            ,approvestatus -- 流程状态
            ,hascancel -- 是否已撤销Y是N否默认可以为空
            ,isopen -- 是否释放敞口
            ,batchserialno -- 批次流水
            ,initexchangeserialno -- 原交易流水号
            ,exchangetime -- 交易日期
            ,interestrate -- 协议利率
            ,bailsum -- 已缴保证金金额
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,contractno -- 合同流水号
            ,putoutno -- 出账流水号
            ,matudt -- 到期日期票据到期日
            ,subaccount -- 子户号
            ,exchangeserialno -- 交易流水号
            ,businesstype -- 转出业务类型
            ,otsusbtp -- 冻结止付方式
            ,updateorgid -- 更新机构
            ,tranam -- 金额
            ,exchangestate -- 交易状态
            ,dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
            ,balance -- 业务余额
            ,inputdate -- 登记日期
            ,grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
            ,putoutdate -- 业务起贷日
            ,pdrifd -- 利率浮动类型
            ,isdiscountflag -- 是否当前借款人
            ,migtflag -- 
            ,cusid -- 客户ID
            ,interestmethod -- 计息方法
            ,maturity -- 业务到期日
            ,prcsna -- 表外摘要
            ,acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
            ,opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
            ,termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
            ,otfrsptp -- 冻结止付类型
            ,otfzremk -- 冻结止付原因
            ,initexchangedate -- 原交易日期
            ,businesssum -- 业务金额
            ,otrvacna -- 表外账号名
            ,updatedate -- 更新日期
            ,acctno -- 转出账号
            ,otfrozsq -- 子户冻结流水
            ,pdrifm -- 利率浮动方式
            ,inputtype -- 生成来源
            ,bailinterestmethod -- 保证金账户属性
            ,deposittermtype -- 保证金账户属性
            ,depositterm -- 存期期限
            ,bailinterestrate -- 保证金执行（协议）利率
            ,depositbaserate -- 存款基准利率
            ,bailterm -- 保证金利率档次
            ,bailbalanceamt -- 保证金余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_deposit_apply_info_op(
            serialno -- 申请流水号
            ,remake -- 追加说明
            ,cusname -- 客户名称
            ,grteac -- 保证金帐号
            ,pigeonholedate -- 归档日期
            ,pdrifv -- 浮动值
            ,inputorgid -- 登记机构
            ,cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
            ,exchangedate -- 交易日期
            ,otrvbldn -- 表外记账方向
            ,crcycd -- 币种
            ,otrvacno -- 表外账号
            ,fxfltp -- 利率类型（核心crgtrt加）
            ,approvestatus -- 流程状态
            ,hascancel -- 是否已撤销Y是N否默认可以为空
            ,isopen -- 是否释放敞口
            ,batchserialno -- 批次流水
            ,initexchangeserialno -- 原交易流水号
            ,exchangetime -- 交易日期
            ,interestrate -- 协议利率
            ,bailsum -- 已缴保证金金额
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,contractno -- 合同流水号
            ,putoutno -- 出账流水号
            ,matudt -- 到期日期票据到期日
            ,subaccount -- 子户号
            ,exchangeserialno -- 交易流水号
            ,businesstype -- 转出业务类型
            ,otsusbtp -- 冻结止付方式
            ,updateorgid -- 更新机构
            ,tranam -- 金额
            ,exchangestate -- 交易状态
            ,dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
            ,balance -- 业务余额
            ,inputdate -- 登记日期
            ,grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
            ,putoutdate -- 业务起贷日
            ,pdrifd -- 利率浮动类型
            ,isdiscountflag -- 是否当前借款人
            ,migtflag -- 
            ,cusid -- 客户ID
            ,interestmethod -- 计息方法
            ,maturity -- 业务到期日
            ,prcsna -- 表外摘要
            ,acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
            ,opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
            ,termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
            ,otfrsptp -- 冻结止付类型
            ,otfzremk -- 冻结止付原因
            ,initexchangedate -- 原交易日期
            ,businesssum -- 业务金额
            ,otrvacna -- 表外账号名
            ,updatedate -- 更新日期
            ,acctno -- 转出账号
            ,otfrozsq -- 子户冻结流水
            ,pdrifm -- 利率浮动方式
            ,inputtype -- 生成来源
            ,bailinterestmethod -- 保证金账户属性
            ,deposittermtype -- 保证金账户属性
            ,depositterm -- 存期期限
            ,bailinterestrate -- 保证金执行（协议）利率
            ,depositbaserate -- 存款基准利率
            ,bailterm -- 保证金利率档次
            ,bailbalanceamt -- 保证金余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 申请流水号
    ,nvl(n.remake, o.remake) as remake -- 追加说明
    ,nvl(n.cusname, o.cusname) as cusname -- 客户名称
    ,nvl(n.grteac, o.grteac) as grteac -- 保证金帐号
    ,nvl(n.pigeonholedate, o.pigeonholedate) as pigeonholedate -- 归档日期
    ,nvl(n.pdrifv, o.pdrifv) as pdrifv -- 浮动值
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.cntrtp, o.cntrtp) as cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
    ,nvl(n.exchangedate, o.exchangedate) as exchangedate -- 交易日期
    ,nvl(n.otrvbldn, o.otrvbldn) as otrvbldn -- 表外记账方向
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种
    ,nvl(n.otrvacno, o.otrvacno) as otrvacno -- 表外账号
    ,nvl(n.fxfltp, o.fxfltp) as fxfltp -- 利率类型（核心crgtrt加）
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 流程状态
    ,nvl(n.hascancel, o.hascancel) as hascancel -- 是否已撤销Y是N否默认可以为空
    ,nvl(n.isopen, o.isopen) as isopen -- 是否释放敞口
    ,nvl(n.batchserialno, o.batchserialno) as batchserialno -- 批次流水
    ,nvl(n.initexchangeserialno, o.initexchangeserialno) as initexchangeserialno -- 原交易流水号
    ,nvl(n.exchangetime, o.exchangetime) as exchangetime -- 交易日期
    ,nvl(n.interestrate, o.interestrate) as interestrate -- 协议利率
    ,nvl(n.bailsum, o.bailsum) as bailsum -- 已缴保证金金额
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.contractno, o.contractno) as contractno -- 合同流水号
    ,nvl(n.putoutno, o.putoutno) as putoutno -- 出账流水号
    ,nvl(n.matudt, o.matudt) as matudt -- 到期日期票据到期日
    ,nvl(n.subaccount, o.subaccount) as subaccount -- 子户号
    ,nvl(n.exchangeserialno, o.exchangeserialno) as exchangeserialno -- 交易流水号
    ,nvl(n.businesstype, o.businesstype) as businesstype -- 转出业务类型
    ,nvl(n.otsusbtp, o.otsusbtp) as otsusbtp -- 冻结止付方式
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.tranam, o.tranam) as tranam -- 金额
    ,nvl(n.exchangestate, o.exchangestate) as exchangestate -- 交易状态
    ,nvl(n.dataid, o.dataid) as dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
    ,nvl(n.balance, o.balance) as balance -- 业务余额
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.grtetp, o.grtetp) as grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
    ,nvl(n.putoutdate, o.putoutdate) as putoutdate -- 业务起贷日
    ,nvl(n.pdrifd, o.pdrifd) as pdrifd -- 利率浮动类型
    ,nvl(n.isdiscountflag, o.isdiscountflag) as isdiscountflag -- 是否当前借款人
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.cusid, o.cusid) as cusid -- 客户ID
    ,nvl(n.interestmethod, o.interestmethod) as interestmethod -- 计息方法
    ,nvl(n.maturity, o.maturity) as maturity -- 业务到期日
    ,nvl(n.prcsna, o.prcsna) as prcsna -- 表外摘要
    ,nvl(n.acptno, o.acptno) as acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
    ,nvl(n.opertp, o.opertp) as opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
    ,nvl(n.termcd, o.termcd) as termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
    ,nvl(n.otfrsptp, o.otfrsptp) as otfrsptp -- 冻结止付类型
    ,nvl(n.otfzremk, o.otfzremk) as otfzremk -- 冻结止付原因
    ,nvl(n.initexchangedate, o.initexchangedate) as initexchangedate -- 原交易日期
    ,nvl(n.businesssum, o.businesssum) as businesssum -- 业务金额
    ,nvl(n.otrvacna, o.otrvacna) as otrvacna -- 表外账号名
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.acctno, o.acctno) as acctno -- 转出账号
    ,nvl(n.otfrozsq, o.otfrozsq) as otfrozsq -- 子户冻结流水
    ,nvl(n.pdrifm, o.pdrifm) as pdrifm -- 利率浮动方式
    ,nvl(n.inputtype, o.inputtype) as inputtype -- 生成来源
    ,nvl(n.bailinterestmethod, o.bailinterestmethod) as bailinterestmethod -- 保证金账户属性
    ,nvl(n.deposittermtype, o.deposittermtype) as deposittermtype -- 保证金账户属性
    ,nvl(n.depositterm, o.depositterm) as depositterm -- 存期期限
    ,nvl(n.bailinterestrate, o.bailinterestrate) as bailinterestrate -- 保证金执行（协议）利率
    ,nvl(n.depositbaserate, o.depositbaserate) as depositbaserate -- 存款基准利率
    ,nvl(n.bailterm, o.bailterm) as bailterm -- 保证金利率档次
    ,nvl(n.bailbalanceamt, o.bailbalanceamt) as bailbalanceamt -- 保证金余额
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_deposit_apply_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_deposit_apply_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.remake <> n.remake
        or o.cusname <> n.cusname
        or o.grteac <> n.grteac
        or o.pigeonholedate <> n.pigeonholedate
        or o.pdrifv <> n.pdrifv
        or o.inputorgid <> n.inputorgid
        or o.cntrtp <> n.cntrtp
        or o.exchangedate <> n.exchangedate
        or o.otrvbldn <> n.otrvbldn
        or o.crcycd <> n.crcycd
        or o.otrvacno <> n.otrvacno
        or o.fxfltp <> n.fxfltp
        or o.approvestatus <> n.approvestatus
        or o.hascancel <> n.hascancel
        or o.isopen <> n.isopen
        or o.batchserialno <> n.batchserialno
        or o.initexchangeserialno <> n.initexchangeserialno
        or o.exchangetime <> n.exchangetime
        or o.interestrate <> n.interestrate
        or o.bailsum <> n.bailsum
        or o.inputuserid <> n.inputuserid
        or o.updateuserid <> n.updateuserid
        or o.contractno <> n.contractno
        or o.putoutno <> n.putoutno
        or o.matudt <> n.matudt
        or o.subaccount <> n.subaccount
        or o.exchangeserialno <> n.exchangeserialno
        or o.businesstype <> n.businesstype
        or o.otsusbtp <> n.otsusbtp
        or o.updateorgid <> n.updateorgid
        or o.tranam <> n.tranam
        or o.exchangestate <> n.exchangestate
        or o.dataid <> n.dataid
        or o.balance <> n.balance
        or o.inputdate <> n.inputdate
        or o.grtetp <> n.grtetp
        or o.putoutdate <> n.putoutdate
        or o.pdrifd <> n.pdrifd
        or o.isdiscountflag <> n.isdiscountflag
        or o.migtflag <> n.migtflag
        or o.cusid <> n.cusid
        or o.interestmethod <> n.interestmethod
        or o.maturity <> n.maturity
        or o.prcsna <> n.prcsna
        or o.acptno <> n.acptno
        or o.opertp <> n.opertp
        or o.termcd <> n.termcd
        or o.otfrsptp <> n.otfrsptp
        or o.otfzremk <> n.otfzremk
        or o.initexchangedate <> n.initexchangedate
        or o.businesssum <> n.businesssum
        or o.otrvacna <> n.otrvacna
        or o.updatedate <> n.updatedate
        or o.acctno <> n.acctno
        or o.otfrozsq <> n.otfrozsq
        or o.pdrifm <> n.pdrifm
        or o.inputtype <> n.inputtype
        or o.bailinterestmethod <> n.bailinterestmethod
        or o.deposittermtype <> n.deposittermtype
        or o.depositterm <> n.depositterm
        or o.bailinterestrate <> n.bailinterestrate
        or o.depositbaserate <> n.depositbaserate
        or o.bailterm <> n.bailterm
        or o.bailbalanceamt <> n.bailbalanceamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_deposit_apply_info_cl(
            serialno -- 申请流水号
            ,remake -- 追加说明
            ,cusname -- 客户名称
            ,grteac -- 保证金帐号
            ,pigeonholedate -- 归档日期
            ,pdrifv -- 浮动值
            ,inputorgid -- 登记机构
            ,cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
            ,exchangedate -- 交易日期
            ,otrvbldn -- 表外记账方向
            ,crcycd -- 币种
            ,otrvacno -- 表外账号
            ,fxfltp -- 利率类型（核心crgtrt加）
            ,approvestatus -- 流程状态
            ,hascancel -- 是否已撤销Y是N否默认可以为空
            ,isopen -- 是否释放敞口
            ,batchserialno -- 批次流水
            ,initexchangeserialno -- 原交易流水号
            ,exchangetime -- 交易日期
            ,interestrate -- 协议利率
            ,bailsum -- 已缴保证金金额
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,contractno -- 合同流水号
            ,putoutno -- 出账流水号
            ,matudt -- 到期日期票据到期日
            ,subaccount -- 子户号
            ,exchangeserialno -- 交易流水号
            ,businesstype -- 转出业务类型
            ,otsusbtp -- 冻结止付方式
            ,updateorgid -- 更新机构
            ,tranam -- 金额
            ,exchangestate -- 交易状态
            ,dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
            ,balance -- 业务余额
            ,inputdate -- 登记日期
            ,grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
            ,putoutdate -- 业务起贷日
            ,pdrifd -- 利率浮动类型
            ,isdiscountflag -- 是否当前借款人
            ,migtflag -- 
            ,cusid -- 客户ID
            ,interestmethod -- 计息方法
            ,maturity -- 业务到期日
            ,prcsna -- 表外摘要
            ,acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
            ,opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
            ,termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
            ,otfrsptp -- 冻结止付类型
            ,otfzremk -- 冻结止付原因
            ,initexchangedate -- 原交易日期
            ,businesssum -- 业务金额
            ,otrvacna -- 表外账号名
            ,updatedate -- 更新日期
            ,acctno -- 转出账号
            ,otfrozsq -- 子户冻结流水
            ,pdrifm -- 利率浮动方式
            ,inputtype -- 生成来源
            ,bailinterestmethod -- 保证金账户属性
            ,deposittermtype -- 保证金账户属性
            ,depositterm -- 存期期限
            ,bailinterestrate -- 保证金执行（协议）利率
            ,depositbaserate -- 存款基准利率
            ,bailterm -- 保证金利率档次
            ,bailbalanceamt -- 保证金余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_deposit_apply_info_op(
            serialno -- 申请流水号
            ,remake -- 追加说明
            ,cusname -- 客户名称
            ,grteac -- 保证金帐号
            ,pigeonholedate -- 归档日期
            ,pdrifv -- 浮动值
            ,inputorgid -- 登记机构
            ,cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
            ,exchangedate -- 交易日期
            ,otrvbldn -- 表外记账方向
            ,crcycd -- 币种
            ,otrvacno -- 表外账号
            ,fxfltp -- 利率类型（核心crgtrt加）
            ,approvestatus -- 流程状态
            ,hascancel -- 是否已撤销Y是N否默认可以为空
            ,isopen -- 是否释放敞口
            ,batchserialno -- 批次流水
            ,initexchangeserialno -- 原交易流水号
            ,exchangetime -- 交易日期
            ,interestrate -- 协议利率
            ,bailsum -- 已缴保证金金额
            ,inputuserid -- 登记人
            ,updateuserid -- 更新人
            ,contractno -- 合同流水号
            ,putoutno -- 出账流水号
            ,matudt -- 到期日期票据到期日
            ,subaccount -- 子户号
            ,exchangeserialno -- 交易流水号
            ,businesstype -- 转出业务类型
            ,otsusbtp -- 冻结止付方式
            ,updateorgid -- 更新机构
            ,tranam -- 金额
            ,exchangestate -- 交易状态
            ,dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
            ,balance -- 业务余额
            ,inputdate -- 登记日期
            ,grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
            ,putoutdate -- 业务起贷日
            ,pdrifd -- 利率浮动类型
            ,isdiscountflag -- 是否当前借款人
            ,migtflag -- 
            ,cusid -- 客户ID
            ,interestmethod -- 计息方法
            ,maturity -- 业务到期日
            ,prcsna -- 表外摘要
            ,acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
            ,opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
            ,termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
            ,otfrsptp -- 冻结止付类型
            ,otfzremk -- 冻结止付原因
            ,initexchangedate -- 原交易日期
            ,businesssum -- 业务金额
            ,otrvacna -- 表外账号名
            ,updatedate -- 更新日期
            ,acctno -- 转出账号
            ,otfrozsq -- 子户冻结流水
            ,pdrifm -- 利率浮动方式
            ,inputtype -- 生成来源
            ,bailinterestmethod -- 保证金账户属性
            ,deposittermtype -- 保证金账户属性
            ,depositterm -- 存期期限
            ,bailinterestrate -- 保证金执行（协议）利率
            ,depositbaserate -- 存款基准利率
            ,bailterm -- 保证金利率档次
            ,bailbalanceamt -- 保证金余额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 申请流水号
    ,o.remake -- 追加说明
    ,o.cusname -- 客户名称
    ,o.grteac -- 保证金帐号
    ,o.pigeonholedate -- 归档日期
    ,o.pdrifv -- 浮动值
    ,o.inputorgid -- 登记机构
    ,o.cntrtp -- 协议类型1--承兑汇票协议 2–保函合同
    ,o.exchangedate -- 交易日期
    ,o.otrvbldn -- 表外记账方向
    ,o.crcycd -- 币种
    ,o.otrvacno -- 表外账号
    ,o.fxfltp -- 利率类型（核心crgtrt加）
    ,o.approvestatus -- 流程状态
    ,o.hascancel -- 是否已撤销Y是N否默认可以为空
    ,o.isopen -- 是否释放敞口
    ,o.batchserialno -- 批次流水
    ,o.initexchangeserialno -- 原交易流水号
    ,o.exchangetime -- 交易日期
    ,o.interestrate -- 协议利率
    ,o.bailsum -- 已缴保证金金额
    ,o.inputuserid -- 登记人
    ,o.updateuserid -- 更新人
    ,o.contractno -- 合同流水号
    ,o.putoutno -- 出账流水号
    ,o.matudt -- 到期日期票据到期日
    ,o.subaccount -- 子户号
    ,o.exchangeserialno -- 交易流水号
    ,o.businesstype -- 转出业务类型
    ,o.otsusbtp -- 冻结止付方式
    ,o.updateorgid -- 更新机构
    ,o.tranam -- 金额
    ,o.exchangestate -- 交易状态
    ,o.dataid -- 唯一标识若为票据系统签发的承兑，则上送票据系统交易唯一标识 若为核心系统签发的承兑，则上送承兑协议号 若为保函，则上送保函合同号
    ,o.balance -- 业务余额
    ,o.inputdate -- 登记日期
    ,o.grtetp -- 保证金类型/备款类型1--关联合同号 2--关联票据号 (保函与票据系统不用上送，默认为1)
    ,o.putoutdate -- 业务起贷日
    ,o.pdrifd -- 利率浮动类型
    ,o.isdiscountflag -- 是否当前借款人
    ,o.migtflag -- 
    ,o.cusid -- 客户ID
    ,o.interestmethod -- 计息方法
    ,o.maturity -- 业务到期日
    ,o.prcsna -- 表外摘要
    ,o.acptno -- 票据号码此字段针对承兑（若grtetp为2时此字段不能为空）
    ,o.opertp -- 操作类型1--建立保证金对应关系 2–追加保证金
    ,o.termcd -- 存期000活期 203三个月 206六个月 301一年 302二年 303三年 305五年
    ,o.otfrsptp -- 冻结止付类型
    ,o.otfzremk -- 冻结止付原因
    ,o.initexchangedate -- 原交易日期
    ,o.businesssum -- 业务金额
    ,o.otrvacna -- 表外账号名
    ,o.updatedate -- 更新日期
    ,o.acctno -- 转出账号
    ,o.otfrozsq -- 子户冻结流水
    ,o.pdrifm -- 利率浮动方式
    ,o.inputtype -- 生成来源
    ,o.bailinterestmethod -- 保证金账户属性
    ,o.deposittermtype -- 保证金账户属性
    ,o.depositterm -- 存期期限
    ,o.bailinterestrate -- 保证金执行（协议）利率
    ,o.depositbaserate -- 存款基准利率
    ,o.bailterm -- 保证金利率档次
    ,o.bailbalanceamt -- 保证金余额
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
from ${iol_schema}.icms_deposit_apply_info_bk o
    left join ${iol_schema}.icms_deposit_apply_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_deposit_apply_info_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_deposit_apply_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_deposit_apply_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_deposit_apply_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_deposit_apply_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_deposit_apply_info exchange partition p_${batch_date} with table ${iol_schema}.icms_deposit_apply_info_cl;
alter table ${iol_schema}.icms_deposit_apply_info exchange partition p_20991231 with table ${iol_schema}.icms_deposit_apply_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_deposit_apply_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_deposit_apply_info_op purge;
drop table ${iol_schema}.icms_deposit_apply_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_deposit_apply_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_deposit_apply_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
