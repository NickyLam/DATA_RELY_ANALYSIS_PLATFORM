/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_info
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
create table ${iol_schema}.icms_clr_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_info_op purge;
drop table ${iol_schema}.icms_clr_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_info where 0=1;

create table ${iol_schema}.icms_clr_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_info_cl(
            clrid -- 押品编号
            ,clrname -- 押品名称
            ,clrcerttype -- 押品所有权证类型
            ,clrcertid -- 所有权证编号
            ,clrtypeid -- 押品资产类型编号
            ,approvestatus -- 申请状态
            ,clrcount -- 押品资产数量
            ,country -- 所在国家
            ,province -- 所在省/直辖市
            ,city -- 所在城市
            ,area -- 所在区域
            ,address -- 详细地址
            ,avlgntvalue -- 当前可担保价值
            ,usedgntvalue -- 本行已担保债权金额
            ,othergntvalue -- 其他优先受偿权利金额
            ,currltv -- 当前抵质押率
            ,clrstatus -- 押品状态      0102 冻结,待处置过程中） 02 已处置      0210  拍卖      0220  变卖      0230  账户划扣      0290  转抵债 09 已作废（如到期的金融质押品、损毁或灭失的房产押品）
            ,clrgantstatus -- 押品准入状态 02,已准入未确立押权 03 已确立押权 04 已注销押权
            ,iscomplete -- 必输信息是否完整
            ,isonlyone -- 是否重复
            ,isrightcert -- 权证信息是否完整
            ,isinsurance -- 保险信息是否完整
            ,isnotarization -- 公正信息是否完整
            ,isclrowner -- 权属人信息是否完整
            ,addstatus -- 补登状态
            ,currevalrecordid -- 最新价值评估记录编号
            ,currevalccy -- 最新评估价值币种
            ,currevaldate -- 最新价值评估日期
            ,currevalmode -- 最新价值评估方式
            ,currevalvalue -- 最新评估价值
            ,evalfrq -- 价值重估频率
            ,currmarketprice -- 当前市场参考价
            ,currmpevaltime -- 当前市场参考价值日期
            ,currmpinfosource -- 当前市场参考价信息来源
            ,currmprefindexid -- 当前市场价格关联指数编号
            ,mycurrency -- 我行拥有的抵押品市价币种
            ,mybankclrprice -- 我行拥有的抵押品市价
            ,independenteval -- 市价是否由独立的价值评估者所估计
            ,isreptpledge -- 是否重复抵质押
            ,isinnerreptpledge -- 是否行内重复抵质押
            ,isclrverification -- 是否已核押登记
            ,isclrregister -- 是否已抵质押登记
            ,manageuserid -- 管理人
            ,manageorgid -- 管理机构
            ,writeuserid -- 补录人
            ,writeorgid -- 补录机构
            ,inevalcurrency -- 内部评估价值币种
            ,inevalvaule -- 内部评估价值
            ,exevalcurrency -- 外部评估价值币种
            ,exevalvalue -- 外部评估价值
            ,sourcesystem -- 来源系统
            ,inevaldate -- 内部评估日期
            ,exevaldate -- 外部评估日期
            ,firstevalmode -- 首次评估方式
            ,appraisalorgid -- 评估机构编号
            ,appraisalorgname -- 评估机构名称
            ,currmarketcurrency -- 当前市场参考价值币种
            ,isdataconv -- 是否移植数据
            ,clrowner -- 抵质押物持有人
            ,othersusedgntvalue -- 他行已担保债权金额
            ,priorityclaim -- 债权优先顺位
            ,evalvalueduedate -- 估值到期日
            ,isdisposition -- 是否已处置
            ,disposalmethod -- 处置方式
            ,lastevalvalue -- 上次评估价值
            ,lastevaldate -- 上次价值评估日期
            ,isaddressunique -- 地址是否唯一
            ,poolstatus -- 出入池状态
            ,poolid -- 押品池编号
            ,tempsaveflag -- 暂存标志
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,corporgid -- 法人机构编号
            ,poolouthistory -- 出池历史
            ,clrinoutstatus -- 押品出入库状态
            ,iscommonproperty -- 是否共同财产
            ,isgencust -- 是否代保管
            ,isotherguar -- 是否他行担保
            ,issaveowner -- 是否保存我行
            ,guarsign -- 抵制押品标识（01:有实物，风管, 02:有实物，营运,03:无实物）
            ,issequence -- 是否第一顺位
            ,urgentamount -- 优先受偿权数额
            ,confirmamount -- 我行确认价值
            ,confirmcurrency -- 我行确认价值币种代码
            ,finallyevaldate -- 最新评估日期
            ,clralivestatus -- 押品存续状态(CodeNo:ClrAliveStatus)
            ,clraccountingstatus -- 押品押权状态(CodeNo:ClrAccountingStatus)
            ,clraccessstatus -- 押品准入状态
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,collattype -- 抵质押标识
            ,guaspecialstate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_info_op(
            clrid -- 押品编号
            ,clrname -- 押品名称
            ,clrcerttype -- 押品所有权证类型
            ,clrcertid -- 所有权证编号
            ,clrtypeid -- 押品资产类型编号
            ,approvestatus -- 申请状态
            ,clrcount -- 押品资产数量
            ,country -- 所在国家
            ,province -- 所在省/直辖市
            ,city -- 所在城市
            ,area -- 所在区域
            ,address -- 详细地址
            ,avlgntvalue -- 当前可担保价值
            ,usedgntvalue -- 本行已担保债权金额
            ,othergntvalue -- 其他优先受偿权利金额
            ,currltv -- 当前抵质押率
            ,clrstatus -- 押品状态      0102 冻结,待处置过程中） 02 已处置      0210  拍卖      0220  变卖      0230  账户划扣      0290  转抵债 09 已作废（如到期的金融质押品、损毁或灭失的房产押品）
            ,clrgantstatus -- 押品准入状态 02,已准入未确立押权 03 已确立押权 04 已注销押权
            ,iscomplete -- 必输信息是否完整
            ,isonlyone -- 是否重复
            ,isrightcert -- 权证信息是否完整
            ,isinsurance -- 保险信息是否完整
            ,isnotarization -- 公正信息是否完整
            ,isclrowner -- 权属人信息是否完整
            ,addstatus -- 补登状态
            ,currevalrecordid -- 最新价值评估记录编号
            ,currevalccy -- 最新评估价值币种
            ,currevaldate -- 最新价值评估日期
            ,currevalmode -- 最新价值评估方式
            ,currevalvalue -- 最新评估价值
            ,evalfrq -- 价值重估频率
            ,currmarketprice -- 当前市场参考价
            ,currmpevaltime -- 当前市场参考价值日期
            ,currmpinfosource -- 当前市场参考价信息来源
            ,currmprefindexid -- 当前市场价格关联指数编号
            ,mycurrency -- 我行拥有的抵押品市价币种
            ,mybankclrprice -- 我行拥有的抵押品市价
            ,independenteval -- 市价是否由独立的价值评估者所估计
            ,isreptpledge -- 是否重复抵质押
            ,isinnerreptpledge -- 是否行内重复抵质押
            ,isclrverification -- 是否已核押登记
            ,isclrregister -- 是否已抵质押登记
            ,manageuserid -- 管理人
            ,manageorgid -- 管理机构
            ,writeuserid -- 补录人
            ,writeorgid -- 补录机构
            ,inevalcurrency -- 内部评估价值币种
            ,inevalvaule -- 内部评估价值
            ,exevalcurrency -- 外部评估价值币种
            ,exevalvalue -- 外部评估价值
            ,sourcesystem -- 来源系统
            ,inevaldate -- 内部评估日期
            ,exevaldate -- 外部评估日期
            ,firstevalmode -- 首次评估方式
            ,appraisalorgid -- 评估机构编号
            ,appraisalorgname -- 评估机构名称
            ,currmarketcurrency -- 当前市场参考价值币种
            ,isdataconv -- 是否移植数据
            ,clrowner -- 抵质押物持有人
            ,othersusedgntvalue -- 他行已担保债权金额
            ,priorityclaim -- 债权优先顺位
            ,evalvalueduedate -- 估值到期日
            ,isdisposition -- 是否已处置
            ,disposalmethod -- 处置方式
            ,lastevalvalue -- 上次评估价值
            ,lastevaldate -- 上次价值评估日期
            ,isaddressunique -- 地址是否唯一
            ,poolstatus -- 出入池状态
            ,poolid -- 押品池编号
            ,tempsaveflag -- 暂存标志
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,corporgid -- 法人机构编号
            ,poolouthistory -- 出池历史
            ,clrinoutstatus -- 押品出入库状态
            ,iscommonproperty -- 是否共同财产
            ,isgencust -- 是否代保管
            ,isotherguar -- 是否他行担保
            ,issaveowner -- 是否保存我行
            ,guarsign -- 抵制押品标识（01:有实物，风管, 02:有实物，营运,03:无实物）
            ,issequence -- 是否第一顺位
            ,urgentamount -- 优先受偿权数额
            ,confirmamount -- 我行确认价值
            ,confirmcurrency -- 我行确认价值币种代码
            ,finallyevaldate -- 最新评估日期
            ,clralivestatus -- 押品存续状态(CodeNo:ClrAliveStatus)
            ,clraccountingstatus -- 押品押权状态(CodeNo:ClrAccountingStatus)
            ,clraccessstatus -- 押品准入状态
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,collattype -- 抵质押标识
            ,guaspecialstate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.clrname, o.clrname) as clrname -- 押品名称
    ,nvl(n.clrcerttype, o.clrcerttype) as clrcerttype -- 押品所有权证类型
    ,nvl(n.clrcertid, o.clrcertid) as clrcertid -- 所有权证编号
    ,nvl(n.clrtypeid, o.clrtypeid) as clrtypeid -- 押品资产类型编号
    ,nvl(n.approvestatus, o.approvestatus) as approvestatus -- 申请状态
    ,nvl(n.clrcount, o.clrcount) as clrcount -- 押品资产数量
    ,nvl(n.country, o.country) as country -- 所在国家
    ,nvl(n.province, o.province) as province -- 所在省/直辖市
    ,nvl(n.city, o.city) as city -- 所在城市
    ,nvl(n.area, o.area) as area -- 所在区域
    ,nvl(n.address, o.address) as address -- 详细地址
    ,nvl(n.avlgntvalue, o.avlgntvalue) as avlgntvalue -- 当前可担保价值
    ,nvl(n.usedgntvalue, o.usedgntvalue) as usedgntvalue -- 本行已担保债权金额
    ,nvl(n.othergntvalue, o.othergntvalue) as othergntvalue -- 其他优先受偿权利金额
    ,nvl(n.currltv, o.currltv) as currltv -- 当前抵质押率
    ,nvl(n.clrstatus, o.clrstatus) as clrstatus -- 押品状态      0102 冻结,待处置过程中） 02 已处置      0210  拍卖      0220  变卖      0230  账户划扣      0290  转抵债 09 已作废（如到期的金融质押品、损毁或灭失的房产押品）
    ,nvl(n.clrgantstatus, o.clrgantstatus) as clrgantstatus -- 押品准入状态 02,已准入未确立押权 03 已确立押权 04 已注销押权
    ,nvl(n.iscomplete, o.iscomplete) as iscomplete -- 必输信息是否完整
    ,nvl(n.isonlyone, o.isonlyone) as isonlyone -- 是否重复
    ,nvl(n.isrightcert, o.isrightcert) as isrightcert -- 权证信息是否完整
    ,nvl(n.isinsurance, o.isinsurance) as isinsurance -- 保险信息是否完整
    ,nvl(n.isnotarization, o.isnotarization) as isnotarization -- 公正信息是否完整
    ,nvl(n.isclrowner, o.isclrowner) as isclrowner -- 权属人信息是否完整
    ,nvl(n.addstatus, o.addstatus) as addstatus -- 补登状态
    ,nvl(n.currevalrecordid, o.currevalrecordid) as currevalrecordid -- 最新价值评估记录编号
    ,nvl(n.currevalccy, o.currevalccy) as currevalccy -- 最新评估价值币种
    ,nvl(n.currevaldate, o.currevaldate) as currevaldate -- 最新价值评估日期
    ,nvl(n.currevalmode, o.currevalmode) as currevalmode -- 最新价值评估方式
    ,nvl(n.currevalvalue, o.currevalvalue) as currevalvalue -- 最新评估价值
    ,nvl(n.evalfrq, o.evalfrq) as evalfrq -- 价值重估频率
    ,nvl(n.currmarketprice, o.currmarketprice) as currmarketprice -- 当前市场参考价
    ,nvl(n.currmpevaltime, o.currmpevaltime) as currmpevaltime -- 当前市场参考价值日期
    ,nvl(n.currmpinfosource, o.currmpinfosource) as currmpinfosource -- 当前市场参考价信息来源
    ,nvl(n.currmprefindexid, o.currmprefindexid) as currmprefindexid -- 当前市场价格关联指数编号
    ,nvl(n.mycurrency, o.mycurrency) as mycurrency -- 我行拥有的抵押品市价币种
    ,nvl(n.mybankclrprice, o.mybankclrprice) as mybankclrprice -- 我行拥有的抵押品市价
    ,nvl(n.independenteval, o.independenteval) as independenteval -- 市价是否由独立的价值评估者所估计
    ,nvl(n.isreptpledge, o.isreptpledge) as isreptpledge -- 是否重复抵质押
    ,nvl(n.isinnerreptpledge, o.isinnerreptpledge) as isinnerreptpledge -- 是否行内重复抵质押
    ,nvl(n.isclrverification, o.isclrverification) as isclrverification -- 是否已核押登记
    ,nvl(n.isclrregister, o.isclrregister) as isclrregister -- 是否已抵质押登记
    ,nvl(n.manageuserid, o.manageuserid) as manageuserid -- 管理人
    ,nvl(n.manageorgid, o.manageorgid) as manageorgid -- 管理机构
    ,nvl(n.writeuserid, o.writeuserid) as writeuserid -- 补录人
    ,nvl(n.writeorgid, o.writeorgid) as writeorgid -- 补录机构
    ,nvl(n.inevalcurrency, o.inevalcurrency) as inevalcurrency -- 内部评估价值币种
    ,nvl(n.inevalvaule, o.inevalvaule) as inevalvaule -- 内部评估价值
    ,nvl(n.exevalcurrency, o.exevalcurrency) as exevalcurrency -- 外部评估价值币种
    ,nvl(n.exevalvalue, o.exevalvalue) as exevalvalue -- 外部评估价值
    ,nvl(n.sourcesystem, o.sourcesystem) as sourcesystem -- 来源系统
    ,nvl(n.inevaldate, o.inevaldate) as inevaldate -- 内部评估日期
    ,nvl(n.exevaldate, o.exevaldate) as exevaldate -- 外部评估日期
    ,nvl(n.firstevalmode, o.firstevalmode) as firstevalmode -- 首次评估方式
    ,nvl(n.appraisalorgid, o.appraisalorgid) as appraisalorgid -- 评估机构编号
    ,nvl(n.appraisalorgname, o.appraisalorgname) as appraisalorgname -- 评估机构名称
    ,nvl(n.currmarketcurrency, o.currmarketcurrency) as currmarketcurrency -- 当前市场参考价值币种
    ,nvl(n.isdataconv, o.isdataconv) as isdataconv -- 是否移植数据
    ,nvl(n.clrowner, o.clrowner) as clrowner -- 抵质押物持有人
    ,nvl(n.othersusedgntvalue, o.othersusedgntvalue) as othersusedgntvalue -- 他行已担保债权金额
    ,nvl(n.priorityclaim, o.priorityclaim) as priorityclaim -- 债权优先顺位
    ,nvl(n.evalvalueduedate, o.evalvalueduedate) as evalvalueduedate -- 估值到期日
    ,nvl(n.isdisposition, o.isdisposition) as isdisposition -- 是否已处置
    ,nvl(n.disposalmethod, o.disposalmethod) as disposalmethod -- 处置方式
    ,nvl(n.lastevalvalue, o.lastevalvalue) as lastevalvalue -- 上次评估价值
    ,nvl(n.lastevaldate, o.lastevaldate) as lastevaldate -- 上次价值评估日期
    ,nvl(n.isaddressunique, o.isaddressunique) as isaddressunique -- 地址是否唯一
    ,nvl(n.poolstatus, o.poolstatus) as poolstatus -- 出入池状态
    ,nvl(n.poolid, o.poolid) as poolid -- 押品池编号
    ,nvl(n.tempsaveflag, o.tempsaveflag) as tempsaveflag -- 暂存标志
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记时间
    ,nvl(n.updateuserid, o.updateuserid) as updateuserid -- 更新人
    ,nvl(n.updateorgid, o.updateorgid) as updateorgid -- 更新机构
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.poolouthistory, o.poolouthistory) as poolouthistory -- 出池历史
    ,nvl(n.clrinoutstatus, o.clrinoutstatus) as clrinoutstatus -- 押品出入库状态
    ,nvl(n.iscommonproperty, o.iscommonproperty) as iscommonproperty -- 是否共同财产
    ,nvl(n.isgencust, o.isgencust) as isgencust -- 是否代保管
    ,nvl(n.isotherguar, o.isotherguar) as isotherguar -- 是否他行担保
    ,nvl(n.issaveowner, o.issaveowner) as issaveowner -- 是否保存我行
    ,nvl(n.guarsign, o.guarsign) as guarsign -- 抵制押品标识（01:有实物，风管, 02:有实物，营运,03:无实物）
    ,nvl(n.issequence, o.issequence) as issequence -- 是否第一顺位
    ,nvl(n.urgentamount, o.urgentamount) as urgentamount -- 优先受偿权数额
    ,nvl(n.confirmamount, o.confirmamount) as confirmamount -- 我行确认价值
    ,nvl(n.confirmcurrency, o.confirmcurrency) as confirmcurrency -- 我行确认价值币种代码
    ,nvl(n.finallyevaldate, o.finallyevaldate) as finallyevaldate -- 最新评估日期
    ,nvl(n.clralivestatus, o.clralivestatus) as clralivestatus -- 押品存续状态(CodeNo:ClrAliveStatus)
    ,nvl(n.clraccountingstatus, o.clraccountingstatus) as clraccountingstatus -- 押品押权状态(CodeNo:ClrAccountingStatus)
    ,nvl(n.clraccessstatus, o.clraccessstatus) as clraccessstatus -- 押品准入状态
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标识：rs rcr ilc upl mim
    ,nvl(n.collattype, o.collattype) as collattype -- 抵质押标识
    ,nvl(n.guaspecialstate, o.guaspecialstate) as guaspecialstate -- 
    ,case when
            n.clrid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.clrid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.clrid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_clr_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.clrid = n.clrid
where (
        o.clrid is null
    )
    or (
        n.clrid is null
    )
    or (
        o.clrname <> n.clrname
        or o.clrcerttype <> n.clrcerttype
        or o.clrcertid <> n.clrcertid
        or o.clrtypeid <> n.clrtypeid
        or o.approvestatus <> n.approvestatus
        or o.clrcount <> n.clrcount
        or o.country <> n.country
        or o.province <> n.province
        or o.city <> n.city
        or o.area <> n.area
        or o.address <> n.address
        or o.avlgntvalue <> n.avlgntvalue
        or o.usedgntvalue <> n.usedgntvalue
        or o.othergntvalue <> n.othergntvalue
        or o.currltv <> n.currltv
        or o.clrstatus <> n.clrstatus
        or o.clrgantstatus <> n.clrgantstatus
        or o.iscomplete <> n.iscomplete
        or o.isonlyone <> n.isonlyone
        or o.isrightcert <> n.isrightcert
        or o.isinsurance <> n.isinsurance
        or o.isnotarization <> n.isnotarization
        or o.isclrowner <> n.isclrowner
        or o.addstatus <> n.addstatus
        or o.currevalrecordid <> n.currevalrecordid
        or o.currevalccy <> n.currevalccy
        or o.currevaldate <> n.currevaldate
        or o.currevalmode <> n.currevalmode
        or o.currevalvalue <> n.currevalvalue
        or o.evalfrq <> n.evalfrq
        or o.currmarketprice <> n.currmarketprice
        or o.currmpevaltime <> n.currmpevaltime
        or o.currmpinfosource <> n.currmpinfosource
        or o.currmprefindexid <> n.currmprefindexid
        or o.mycurrency <> n.mycurrency
        or o.mybankclrprice <> n.mybankclrprice
        or o.independenteval <> n.independenteval
        or o.isreptpledge <> n.isreptpledge
        or o.isinnerreptpledge <> n.isinnerreptpledge
        or o.isclrverification <> n.isclrverification
        or o.isclrregister <> n.isclrregister
        or o.manageuserid <> n.manageuserid
        or o.manageorgid <> n.manageorgid
        or o.writeuserid <> n.writeuserid
        or o.writeorgid <> n.writeorgid
        or o.inevalcurrency <> n.inevalcurrency
        or o.inevalvaule <> n.inevalvaule
        or o.exevalcurrency <> n.exevalcurrency
        or o.exevalvalue <> n.exevalvalue
        or o.sourcesystem <> n.sourcesystem
        or o.inevaldate <> n.inevaldate
        or o.exevaldate <> n.exevaldate
        or o.firstevalmode <> n.firstevalmode
        or o.appraisalorgid <> n.appraisalorgid
        or o.appraisalorgname <> n.appraisalorgname
        or o.currmarketcurrency <> n.currmarketcurrency
        or o.isdataconv <> n.isdataconv
        or o.clrowner <> n.clrowner
        or o.othersusedgntvalue <> n.othersusedgntvalue
        or o.priorityclaim <> n.priorityclaim
        or o.evalvalueduedate <> n.evalvalueduedate
        or o.isdisposition <> n.isdisposition
        or o.disposalmethod <> n.disposalmethod
        or o.lastevalvalue <> n.lastevalvalue
        or o.lastevaldate <> n.lastevaldate
        or o.isaddressunique <> n.isaddressunique
        or o.poolstatus <> n.poolstatus
        or o.poolid <> n.poolid
        or o.tempsaveflag <> n.tempsaveflag
        or o.remark <> n.remark
        or o.inputuserid <> n.inputuserid
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.updateuserid <> n.updateuserid
        or o.updateorgid <> n.updateorgid
        or o.updatedate <> n.updatedate
        or o.corporgid <> n.corporgid
        or o.poolouthistory <> n.poolouthistory
        or o.clrinoutstatus <> n.clrinoutstatus
        or o.iscommonproperty <> n.iscommonproperty
        or o.isgencust <> n.isgencust
        or o.isotherguar <> n.isotherguar
        or o.issaveowner <> n.issaveowner
        or o.guarsign <> n.guarsign
        or o.issequence <> n.issequence
        or o.urgentamount <> n.urgentamount
        or o.confirmamount <> n.confirmamount
        or o.confirmcurrency <> n.confirmcurrency
        or o.finallyevaldate <> n.finallyevaldate
        or o.clralivestatus <> n.clralivestatus
        or o.clraccountingstatus <> n.clraccountingstatus
        or o.clraccessstatus <> n.clraccessstatus
        or o.migtflag <> n.migtflag
        or o.collattype <> n.collattype
        or o.guaspecialstate <> n.guaspecialstate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_info_cl(
            clrid -- 押品编号
            ,clrname -- 押品名称
            ,clrcerttype -- 押品所有权证类型
            ,clrcertid -- 所有权证编号
            ,clrtypeid -- 押品资产类型编号
            ,approvestatus -- 申请状态
            ,clrcount -- 押品资产数量
            ,country -- 所在国家
            ,province -- 所在省/直辖市
            ,city -- 所在城市
            ,area -- 所在区域
            ,address -- 详细地址
            ,avlgntvalue -- 当前可担保价值
            ,usedgntvalue -- 本行已担保债权金额
            ,othergntvalue -- 其他优先受偿权利金额
            ,currltv -- 当前抵质押率
            ,clrstatus -- 押品状态      0102 冻结,待处置过程中） 02 已处置      0210  拍卖      0220  变卖      0230  账户划扣      0290  转抵债 09 已作废（如到期的金融质押品、损毁或灭失的房产押品）
            ,clrgantstatus -- 押品准入状态 02,已准入未确立押权 03 已确立押权 04 已注销押权
            ,iscomplete -- 必输信息是否完整
            ,isonlyone -- 是否重复
            ,isrightcert -- 权证信息是否完整
            ,isinsurance -- 保险信息是否完整
            ,isnotarization -- 公正信息是否完整
            ,isclrowner -- 权属人信息是否完整
            ,addstatus -- 补登状态
            ,currevalrecordid -- 最新价值评估记录编号
            ,currevalccy -- 最新评估价值币种
            ,currevaldate -- 最新价值评估日期
            ,currevalmode -- 最新价值评估方式
            ,currevalvalue -- 最新评估价值
            ,evalfrq -- 价值重估频率
            ,currmarketprice -- 当前市场参考价
            ,currmpevaltime -- 当前市场参考价值日期
            ,currmpinfosource -- 当前市场参考价信息来源
            ,currmprefindexid -- 当前市场价格关联指数编号
            ,mycurrency -- 我行拥有的抵押品市价币种
            ,mybankclrprice -- 我行拥有的抵押品市价
            ,independenteval -- 市价是否由独立的价值评估者所估计
            ,isreptpledge -- 是否重复抵质押
            ,isinnerreptpledge -- 是否行内重复抵质押
            ,isclrverification -- 是否已核押登记
            ,isclrregister -- 是否已抵质押登记
            ,manageuserid -- 管理人
            ,manageorgid -- 管理机构
            ,writeuserid -- 补录人
            ,writeorgid -- 补录机构
            ,inevalcurrency -- 内部评估价值币种
            ,inevalvaule -- 内部评估价值
            ,exevalcurrency -- 外部评估价值币种
            ,exevalvalue -- 外部评估价值
            ,sourcesystem -- 来源系统
            ,inevaldate -- 内部评估日期
            ,exevaldate -- 外部评估日期
            ,firstevalmode -- 首次评估方式
            ,appraisalorgid -- 评估机构编号
            ,appraisalorgname -- 评估机构名称
            ,currmarketcurrency -- 当前市场参考价值币种
            ,isdataconv -- 是否移植数据
            ,clrowner -- 抵质押物持有人
            ,othersusedgntvalue -- 他行已担保债权金额
            ,priorityclaim -- 债权优先顺位
            ,evalvalueduedate -- 估值到期日
            ,isdisposition -- 是否已处置
            ,disposalmethod -- 处置方式
            ,lastevalvalue -- 上次评估价值
            ,lastevaldate -- 上次价值评估日期
            ,isaddressunique -- 地址是否唯一
            ,poolstatus -- 出入池状态
            ,poolid -- 押品池编号
            ,tempsaveflag -- 暂存标志
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,corporgid -- 法人机构编号
            ,poolouthistory -- 出池历史
            ,clrinoutstatus -- 押品出入库状态
            ,iscommonproperty -- 是否共同财产
            ,isgencust -- 是否代保管
            ,isotherguar -- 是否他行担保
            ,issaveowner -- 是否保存我行
            ,guarsign -- 抵制押品标识（01:有实物，风管, 02:有实物，营运,03:无实物）
            ,issequence -- 是否第一顺位
            ,urgentamount -- 优先受偿权数额
            ,confirmamount -- 我行确认价值
            ,confirmcurrency -- 我行确认价值币种代码
            ,finallyevaldate -- 最新评估日期
            ,clralivestatus -- 押品存续状态(CodeNo:ClrAliveStatus)
            ,clraccountingstatus -- 押品押权状态(CodeNo:ClrAccountingStatus)
            ,clraccessstatus -- 押品准入状态
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,collattype -- 抵质押标识
            ,guaspecialstate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_info_op(
            clrid -- 押品编号
            ,clrname -- 押品名称
            ,clrcerttype -- 押品所有权证类型
            ,clrcertid -- 所有权证编号
            ,clrtypeid -- 押品资产类型编号
            ,approvestatus -- 申请状态
            ,clrcount -- 押品资产数量
            ,country -- 所在国家
            ,province -- 所在省/直辖市
            ,city -- 所在城市
            ,area -- 所在区域
            ,address -- 详细地址
            ,avlgntvalue -- 当前可担保价值
            ,usedgntvalue -- 本行已担保债权金额
            ,othergntvalue -- 其他优先受偿权利金额
            ,currltv -- 当前抵质押率
            ,clrstatus -- 押品状态      0102 冻结,待处置过程中） 02 已处置      0210  拍卖      0220  变卖      0230  账户划扣      0290  转抵债 09 已作废（如到期的金融质押品、损毁或灭失的房产押品）
            ,clrgantstatus -- 押品准入状态 02,已准入未确立押权 03 已确立押权 04 已注销押权
            ,iscomplete -- 必输信息是否完整
            ,isonlyone -- 是否重复
            ,isrightcert -- 权证信息是否完整
            ,isinsurance -- 保险信息是否完整
            ,isnotarization -- 公正信息是否完整
            ,isclrowner -- 权属人信息是否完整
            ,addstatus -- 补登状态
            ,currevalrecordid -- 最新价值评估记录编号
            ,currevalccy -- 最新评估价值币种
            ,currevaldate -- 最新价值评估日期
            ,currevalmode -- 最新价值评估方式
            ,currevalvalue -- 最新评估价值
            ,evalfrq -- 价值重估频率
            ,currmarketprice -- 当前市场参考价
            ,currmpevaltime -- 当前市场参考价值日期
            ,currmpinfosource -- 当前市场参考价信息来源
            ,currmprefindexid -- 当前市场价格关联指数编号
            ,mycurrency -- 我行拥有的抵押品市价币种
            ,mybankclrprice -- 我行拥有的抵押品市价
            ,independenteval -- 市价是否由独立的价值评估者所估计
            ,isreptpledge -- 是否重复抵质押
            ,isinnerreptpledge -- 是否行内重复抵质押
            ,isclrverification -- 是否已核押登记
            ,isclrregister -- 是否已抵质押登记
            ,manageuserid -- 管理人
            ,manageorgid -- 管理机构
            ,writeuserid -- 补录人
            ,writeorgid -- 补录机构
            ,inevalcurrency -- 内部评估价值币种
            ,inevalvaule -- 内部评估价值
            ,exevalcurrency -- 外部评估价值币种
            ,exevalvalue -- 外部评估价值
            ,sourcesystem -- 来源系统
            ,inevaldate -- 内部评估日期
            ,exevaldate -- 外部评估日期
            ,firstevalmode -- 首次评估方式
            ,appraisalorgid -- 评估机构编号
            ,appraisalorgname -- 评估机构名称
            ,currmarketcurrency -- 当前市场参考价值币种
            ,isdataconv -- 是否移植数据
            ,clrowner -- 抵质押物持有人
            ,othersusedgntvalue -- 他行已担保债权金额
            ,priorityclaim -- 债权优先顺位
            ,evalvalueduedate -- 估值到期日
            ,isdisposition -- 是否已处置
            ,disposalmethod -- 处置方式
            ,lastevalvalue -- 上次评估价值
            ,lastevaldate -- 上次价值评估日期
            ,isaddressunique -- 地址是否唯一
            ,poolstatus -- 出入池状态
            ,poolid -- 押品池编号
            ,tempsaveflag -- 暂存标志
            ,remark -- 备注
            ,inputuserid -- 登记人
            ,inputorgid -- 登记机构
            ,inputdate -- 登记时间
            ,updateuserid -- 更新人
            ,updateorgid -- 更新机构
            ,updatedate -- 更新时间
            ,corporgid -- 法人机构编号
            ,poolouthistory -- 出池历史
            ,clrinoutstatus -- 押品出入库状态
            ,iscommonproperty -- 是否共同财产
            ,isgencust -- 是否代保管
            ,isotherguar -- 是否他行担保
            ,issaveowner -- 是否保存我行
            ,guarsign -- 抵制押品标识（01:有实物，风管, 02:有实物，营运,03:无实物）
            ,issequence -- 是否第一顺位
            ,urgentamount -- 优先受偿权数额
            ,confirmamount -- 我行确认价值
            ,confirmcurrency -- 我行确认价值币种代码
            ,finallyevaldate -- 最新评估日期
            ,clralivestatus -- 押品存续状态(CodeNo:ClrAliveStatus)
            ,clraccountingstatus -- 押品押权状态(CodeNo:ClrAccountingStatus)
            ,clraccessstatus -- 押品准入状态
            ,migtflag -- 迁移标识：rs rcr ilc upl mim
            ,collattype -- 抵质押标识
            ,guaspecialstate -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.clrid -- 押品编号
    ,o.clrname -- 押品名称
    ,o.clrcerttype -- 押品所有权证类型
    ,o.clrcertid -- 所有权证编号
    ,o.clrtypeid -- 押品资产类型编号
    ,o.approvestatus -- 申请状态
    ,o.clrcount -- 押品资产数量
    ,o.country -- 所在国家
    ,o.province -- 所在省/直辖市
    ,o.city -- 所在城市
    ,o.area -- 所在区域
    ,o.address -- 详细地址
    ,o.avlgntvalue -- 当前可担保价值
    ,o.usedgntvalue -- 本行已担保债权金额
    ,o.othergntvalue -- 其他优先受偿权利金额
    ,o.currltv -- 当前抵质押率
    ,o.clrstatus -- 押品状态      0102 冻结,待处置过程中） 02 已处置      0210  拍卖      0220  变卖      0230  账户划扣      0290  转抵债 09 已作废（如到期的金融质押品、损毁或灭失的房产押品）
    ,o.clrgantstatus -- 押品准入状态 02,已准入未确立押权 03 已确立押权 04 已注销押权
    ,o.iscomplete -- 必输信息是否完整
    ,o.isonlyone -- 是否重复
    ,o.isrightcert -- 权证信息是否完整
    ,o.isinsurance -- 保险信息是否完整
    ,o.isnotarization -- 公正信息是否完整
    ,o.isclrowner -- 权属人信息是否完整
    ,o.addstatus -- 补登状态
    ,o.currevalrecordid -- 最新价值评估记录编号
    ,o.currevalccy -- 最新评估价值币种
    ,o.currevaldate -- 最新价值评估日期
    ,o.currevalmode -- 最新价值评估方式
    ,o.currevalvalue -- 最新评估价值
    ,o.evalfrq -- 价值重估频率
    ,o.currmarketprice -- 当前市场参考价
    ,o.currmpevaltime -- 当前市场参考价值日期
    ,o.currmpinfosource -- 当前市场参考价信息来源
    ,o.currmprefindexid -- 当前市场价格关联指数编号
    ,o.mycurrency -- 我行拥有的抵押品市价币种
    ,o.mybankclrprice -- 我行拥有的抵押品市价
    ,o.independenteval -- 市价是否由独立的价值评估者所估计
    ,o.isreptpledge -- 是否重复抵质押
    ,o.isinnerreptpledge -- 是否行内重复抵质押
    ,o.isclrverification -- 是否已核押登记
    ,o.isclrregister -- 是否已抵质押登记
    ,o.manageuserid -- 管理人
    ,o.manageorgid -- 管理机构
    ,o.writeuserid -- 补录人
    ,o.writeorgid -- 补录机构
    ,o.inevalcurrency -- 内部评估价值币种
    ,o.inevalvaule -- 内部评估价值
    ,o.exevalcurrency -- 外部评估价值币种
    ,o.exevalvalue -- 外部评估价值
    ,o.sourcesystem -- 来源系统
    ,o.inevaldate -- 内部评估日期
    ,o.exevaldate -- 外部评估日期
    ,o.firstevalmode -- 首次评估方式
    ,o.appraisalorgid -- 评估机构编号
    ,o.appraisalorgname -- 评估机构名称
    ,o.currmarketcurrency -- 当前市场参考价值币种
    ,o.isdataconv -- 是否移植数据
    ,o.clrowner -- 抵质押物持有人
    ,o.othersusedgntvalue -- 他行已担保债权金额
    ,o.priorityclaim -- 债权优先顺位
    ,o.evalvalueduedate -- 估值到期日
    ,o.isdisposition -- 是否已处置
    ,o.disposalmethod -- 处置方式
    ,o.lastevalvalue -- 上次评估价值
    ,o.lastevaldate -- 上次价值评估日期
    ,o.isaddressunique -- 地址是否唯一
    ,o.poolstatus -- 出入池状态
    ,o.poolid -- 押品池编号
    ,o.tempsaveflag -- 暂存标志
    ,o.remark -- 备注
    ,o.inputuserid -- 登记人
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记时间
    ,o.updateuserid -- 更新人
    ,o.updateorgid -- 更新机构
    ,o.updatedate -- 更新时间
    ,o.corporgid -- 法人机构编号
    ,o.poolouthistory -- 出池历史
    ,o.clrinoutstatus -- 押品出入库状态
    ,o.iscommonproperty -- 是否共同财产
    ,o.isgencust -- 是否代保管
    ,o.isotherguar -- 是否他行担保
    ,o.issaveowner -- 是否保存我行
    ,o.guarsign -- 抵制押品标识（01:有实物，风管, 02:有实物，营运,03:无实物）
    ,o.issequence -- 是否第一顺位
    ,o.urgentamount -- 优先受偿权数额
    ,o.confirmamount -- 我行确认价值
    ,o.confirmcurrency -- 我行确认价值币种代码
    ,o.finallyevaldate -- 最新评估日期
    ,o.clralivestatus -- 押品存续状态(CodeNo:ClrAliveStatus)
    ,o.clraccountingstatus -- 押品押权状态(CodeNo:ClrAccountingStatus)
    ,o.clraccessstatus -- 押品准入状态
    ,o.migtflag -- 迁移标识：rs rcr ilc upl mim
    ,o.collattype -- 抵质押标识
    ,o.guaspecialstate -- 
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
from ${iol_schema}.icms_clr_info_bk o
    left join ${iol_schema}.icms_clr_info_op n
        on
            o.clrid = n.clrid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_info_cl d
        on
            o.clrid = d.clrid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_clr_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_info exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_info_cl;
alter table ${iol_schema}.icms_clr_info exchange partition p_20991231 with table ${iol_schema}.icms_clr_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_info_op purge;
drop table ${iol_schema}.icms_clr_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
