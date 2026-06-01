/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_info(
    clrid varchar2(96) -- 押品编号
    ,clrname varchar2(240) -- 押品名称
    ,clrcerttype varchar2(18) -- 押品所有权证类型
    ,clrcertid varchar2(240) -- 所有权证编号
    ,clrtypeid varchar2(96) -- 押品类型
    ,approvestatus varchar2(96) -- 申请状态
    ,clrcount varchar2(240) -- 押品资产数量
    ,country varchar2(18) -- 所在国家
    ,province varchar2(18) -- 所在省/直辖市
    ,city varchar2(18) -- 所在城市
    ,area varchar2(18) -- 所在区域
    ,address varchar2(1500) -- 详细地址
    ,avlgntvalue number(24,6) -- 当前可担保价值
    ,usedgntvalue number(24,6) -- 本行已担保债权金额
    ,othergntvalue number(24,6) -- 其他优先受偿权利金额
    ,currltv number(12,8) -- 当前抵质押率
    ,clrstatus varchar2(18) -- 押品状态      0102 冻结,待处置过程中） 02 已处置      0210  拍卖      0220  变卖      0230  账户划扣      0290  转抵债 09 已作废（如到期的金融质押品、损毁或灭失的房产押品）
    ,clrgantstatus varchar2(18) -- 押品准入状态 02,已准入未确立押权 03 已确立押权 04 已注销押权
    ,iscomplete varchar2(3) -- 必输信息是否完整
    ,isonlyone varchar2(3) -- 是否重复
    ,isrightcert varchar2(3) -- 权证信息是否完整
    ,isinsurance varchar2(3) -- 保险信息是否完整
    ,isnotarization varchar2(3) -- 公正信息是否完整
    ,isclrowner varchar2(3) -- 权属人信息是否完整
    ,addstatus varchar2(3) -- 补登状态
    ,currevalrecordid varchar2(96) -- 最新价值评估记录编号
    ,currevalccy varchar2(18) -- 最新评估价值币种
    ,currevaldate date -- 最新价值评估日期
    ,currevalmode varchar2(18) -- 最新价值评估方式
    ,currevalvalue number(24,6) -- 最新评估价值
    ,evalfrq number(12,8) -- 价值重估频率
    ,currmarketprice number(24,6) -- 当前市场参考价
    ,currmpevaltime date -- 当前市场参考价值日期
    ,currmpinfosource varchar2(240) -- 当前市场参考价信息来源
    ,currmprefindexid varchar2(96) -- 当前市场价格关联指数编号
    ,mycurrency varchar2(54) -- 我行拥有的抵押品市价币种
    ,mybankclrprice number(24,6) -- 我行拥有的抵押品市价
    ,independenteval varchar2(3) -- 市价是否由独立的价值评估者所估计
    ,isreptpledge varchar2(3) -- 是否重复抵质押
    ,isinnerreptpledge varchar2(3) -- 是否行内重复抵质押
    ,isclrverification varchar2(3) -- 是否已核押登记
    ,isclrregister varchar2(3) -- 是否已抵质押登记
    ,manageuserid varchar2(96) -- 管理人
    ,manageorgid varchar2(96) -- 管理机构
    ,writeuserid varchar2(240) -- 补录人
    ,writeorgid varchar2(96) -- 补录机构
    ,inevalcurrency varchar2(54) -- 内部评估价值币种
    ,inevalvaule number(24,6) -- 内部评估价值
    ,exevalcurrency varchar2(54) -- 外部评估价值币种
    ,exevalvalue number(24,6) -- 外部评估价值
    ,sourcesystem varchar2(240) -- 来源系统
    ,inevaldate date -- 内部评估日期
    ,exevaldate date -- 外部评估日期
    ,firstevalmode varchar2(54) -- 首次评估方式
    ,appraisalorgid varchar2(96) -- 评估机构编号
    ,appraisalorgname varchar2(240) -- 评估机构名称
    ,currmarketcurrency varchar2(54) -- 当前市场参考价值币种
    ,isdataconv varchar2(3) -- 是否移植数据
    ,clrowner varchar2(240) -- 抵质押物持有人
    ,othersusedgntvalue number(24,6) -- 他行已担保债权金额
    ,priorityclaim varchar2(54) -- 债权优先顺位
    ,evalvalueduedate date -- 估值到期日
    ,isdisposition varchar2(3) -- 是否已处置
    ,disposalmethod varchar2(18) -- 处置方式
    ,lastevalvalue number(24,6) -- 上次评估价值
    ,lastevaldate date -- 上次价值评估日期
    ,isaddressunique varchar2(3) -- 地址是否唯一
    ,poolstatus varchar2(18) -- 出入池状态
    ,poolid varchar2(96) -- 押品池编号
    ,tempsaveflag varchar2(18) -- 暂存标志
    ,remark varchar2(1500) -- 备注
    ,inputuserid varchar2(96) -- 登记人
    ,inputorgid varchar2(96) -- 登记机构
    ,inputdate timestamp -- 登记时间
    ,updateuserid varchar2(96) -- 更新人
    ,updateorgid varchar2(96) -- 更新机构
    ,updatedate timestamp -- 更新时间
    ,corporgid varchar2(96) -- 法人机构编号
    ,poolouthistory varchar2(4000) -- 出池历史
    ,clrinoutstatus varchar2(18) -- 押品出入库状态
    ,iscommonproperty varchar2(10) -- 是否共同财产
    ,isgencust varchar2(2) -- 是否代保管
    ,isotherguar varchar2(2) -- 是否他行担保
    ,issaveowner varchar2(2) -- 是否保存我行
    ,guarsign varchar2(2) -- 抵制押品标识（01:有实物，风管, 02:有实物，营运,03:无实物）
    ,issequence varchar2(2) -- 是否第一顺位
    ,urgentamount number(20,2) -- 优先受偿权数额
    ,confirmamount number(20,2) -- 我行确认价值
    ,confirmcurrency varchar2(3) -- 我行确认价值币种代码
    ,finallyevaldate date -- 最新评估日期
    ,clralivestatus varchar2(10) -- 押品出入库状态(CodeNo:ClrAliveStatus)
    ,clraccountingstatus varchar2(10) -- 押品押权状态(CodeNo:ClrAccountingStatus)
    ,clraccessstatus varchar2(18) -- 押品准入状态
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,collattype varchar2(6) -- 抵质押标识
    ,guaspecialstate varchar2(6) -- 
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
grant select on ${iol_schema}.icms_clr_info to ${iml_schema};
grant select on ${iol_schema}.icms_clr_info to ${icl_schema};
grant select on ${iol_schema}.icms_clr_info to ${idl_schema};
grant select on ${iol_schema}.icms_clr_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_info is '押品信息';
comment on column ${iol_schema}.icms_clr_info.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_info.clrname is '押品名称';
comment on column ${iol_schema}.icms_clr_info.clrcerttype is '押品所有权证类型';
comment on column ${iol_schema}.icms_clr_info.clrcertid is '所有权证编号';
comment on column ${iol_schema}.icms_clr_info.clrtypeid is '押品类型';
comment on column ${iol_schema}.icms_clr_info.approvestatus is '申请状态';
comment on column ${iol_schema}.icms_clr_info.clrcount is '押品资产数量';
comment on column ${iol_schema}.icms_clr_info.country is '所在国家';
comment on column ${iol_schema}.icms_clr_info.province is '所在省/直辖市';
comment on column ${iol_schema}.icms_clr_info.city is '所在城市';
comment on column ${iol_schema}.icms_clr_info.area is '所在区域';
comment on column ${iol_schema}.icms_clr_info.address is '详细地址';
comment on column ${iol_schema}.icms_clr_info.avlgntvalue is '当前可担保价值';
comment on column ${iol_schema}.icms_clr_info.usedgntvalue is '本行已担保债权金额';
comment on column ${iol_schema}.icms_clr_info.othergntvalue is '其他优先受偿权利金额';
comment on column ${iol_schema}.icms_clr_info.currltv is '当前抵质押率';
comment on column ${iol_schema}.icms_clr_info.clrstatus is '押品状态      0102 冻结,待处置过程中） 02 已处置      0210  拍卖      0220  变卖      0230  账户划扣      0290  转抵债 09 已作废（如到期的金融质押品、损毁或灭失的房产押品）';
comment on column ${iol_schema}.icms_clr_info.clrgantstatus is '押品准入状态 02,已准入未确立押权 03 已确立押权 04 已注销押权';
comment on column ${iol_schema}.icms_clr_info.iscomplete is '必输信息是否完整';
comment on column ${iol_schema}.icms_clr_info.isonlyone is '是否重复';
comment on column ${iol_schema}.icms_clr_info.isrightcert is '权证信息是否完整';
comment on column ${iol_schema}.icms_clr_info.isinsurance is '保险信息是否完整';
comment on column ${iol_schema}.icms_clr_info.isnotarization is '公正信息是否完整';
comment on column ${iol_schema}.icms_clr_info.isclrowner is '权属人信息是否完整';
comment on column ${iol_schema}.icms_clr_info.addstatus is '补登状态';
comment on column ${iol_schema}.icms_clr_info.currevalrecordid is '最新价值评估记录编号';
comment on column ${iol_schema}.icms_clr_info.currevalccy is '最新评估价值币种';
comment on column ${iol_schema}.icms_clr_info.currevaldate is '最新价值评估日期';
comment on column ${iol_schema}.icms_clr_info.currevalmode is '最新价值评估方式';
comment on column ${iol_schema}.icms_clr_info.currevalvalue is '最新评估价值';
comment on column ${iol_schema}.icms_clr_info.evalfrq is '价值重估频率';
comment on column ${iol_schema}.icms_clr_info.currmarketprice is '当前市场参考价';
comment on column ${iol_schema}.icms_clr_info.currmpevaltime is '当前市场参考价值日期';
comment on column ${iol_schema}.icms_clr_info.currmpinfosource is '当前市场参考价信息来源';
comment on column ${iol_schema}.icms_clr_info.currmprefindexid is '当前市场价格关联指数编号';
comment on column ${iol_schema}.icms_clr_info.mycurrency is '我行拥有的抵押品市价币种';
comment on column ${iol_schema}.icms_clr_info.mybankclrprice is '我行拥有的抵押品市价';
comment on column ${iol_schema}.icms_clr_info.independenteval is '市价是否由独立的价值评估者所估计';
comment on column ${iol_schema}.icms_clr_info.isreptpledge is '是否重复抵质押';
comment on column ${iol_schema}.icms_clr_info.isinnerreptpledge is '是否行内重复抵质押';
comment on column ${iol_schema}.icms_clr_info.isclrverification is '是否已核押登记';
comment on column ${iol_schema}.icms_clr_info.isclrregister is '是否已抵质押登记';
comment on column ${iol_schema}.icms_clr_info.manageuserid is '管理人';
comment on column ${iol_schema}.icms_clr_info.manageorgid is '管理机构';
comment on column ${iol_schema}.icms_clr_info.writeuserid is '补录人';
comment on column ${iol_schema}.icms_clr_info.writeorgid is '补录机构';
comment on column ${iol_schema}.icms_clr_info.inevalcurrency is '内部评估价值币种';
comment on column ${iol_schema}.icms_clr_info.inevalvaule is '内部评估价值';
comment on column ${iol_schema}.icms_clr_info.exevalcurrency is '外部评估价值币种';
comment on column ${iol_schema}.icms_clr_info.exevalvalue is '外部评估价值';
comment on column ${iol_schema}.icms_clr_info.sourcesystem is '来源系统';
comment on column ${iol_schema}.icms_clr_info.inevaldate is '内部评估日期';
comment on column ${iol_schema}.icms_clr_info.exevaldate is '外部评估日期';
comment on column ${iol_schema}.icms_clr_info.firstevalmode is '首次评估方式';
comment on column ${iol_schema}.icms_clr_info.appraisalorgid is '评估机构编号';
comment on column ${iol_schema}.icms_clr_info.appraisalorgname is '评估机构名称';
comment on column ${iol_schema}.icms_clr_info.currmarketcurrency is '当前市场参考价值币种';
comment on column ${iol_schema}.icms_clr_info.isdataconv is '是否移植数据';
comment on column ${iol_schema}.icms_clr_info.clrowner is '抵质押物持有人';
comment on column ${iol_schema}.icms_clr_info.othersusedgntvalue is '他行已担保债权金额';
comment on column ${iol_schema}.icms_clr_info.priorityclaim is '债权优先顺位';
comment on column ${iol_schema}.icms_clr_info.evalvalueduedate is '估值到期日';
comment on column ${iol_schema}.icms_clr_info.isdisposition is '是否已处置';
comment on column ${iol_schema}.icms_clr_info.disposalmethod is '处置方式';
comment on column ${iol_schema}.icms_clr_info.lastevalvalue is '上次评估价值';
comment on column ${iol_schema}.icms_clr_info.lastevaldate is '上次价值评估日期';
comment on column ${iol_schema}.icms_clr_info.isaddressunique is '地址是否唯一';
comment on column ${iol_schema}.icms_clr_info.poolstatus is '出入池状态';
comment on column ${iol_schema}.icms_clr_info.poolid is '押品池编号';
comment on column ${iol_schema}.icms_clr_info.tempsaveflag is '暂存标志';
comment on column ${iol_schema}.icms_clr_info.remark is '备注';
comment on column ${iol_schema}.icms_clr_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_clr_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_clr_info.inputdate is '登记时间';
comment on column ${iol_schema}.icms_clr_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_clr_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_clr_info.updatedate is '更新时间';
comment on column ${iol_schema}.icms_clr_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_clr_info.poolouthistory is '出池历史';
comment on column ${iol_schema}.icms_clr_info.clrinoutstatus is '押品出入库状态';
comment on column ${iol_schema}.icms_clr_info.iscommonproperty is '是否共同财产';
comment on column ${iol_schema}.icms_clr_info.isgencust is '是否代保管';
comment on column ${iol_schema}.icms_clr_info.isotherguar is '是否他行担保';
comment on column ${iol_schema}.icms_clr_info.issaveowner is '是否保存我行';
comment on column ${iol_schema}.icms_clr_info.guarsign is '抵制押品标识（01:有实物，风管, 02:有实物，营运,03:无实物）';
comment on column ${iol_schema}.icms_clr_info.issequence is '是否第一顺位';
comment on column ${iol_schema}.icms_clr_info.urgentamount is '优先受偿权数额';
comment on column ${iol_schema}.icms_clr_info.confirmamount is '我行确认价值';
comment on column ${iol_schema}.icms_clr_info.confirmcurrency is '我行确认价值币种代码';
comment on column ${iol_schema}.icms_clr_info.finallyevaldate is '最新评估日期';
comment on column ${iol_schema}.icms_clr_info.clralivestatus is '押品出入库状态(CodeNo:ClrAliveStatus)';
comment on column ${iol_schema}.icms_clr_info.clraccountingstatus is '押品押权状态(CodeNo:ClrAccountingStatus)';
comment on column ${iol_schema}.icms_clr_info.clraccessstatus is '押品准入状态';
comment on column ${iol_schema}.icms_clr_info.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_info.collattype is '抵质押标识';
comment on column ${iol_schema}.icms_clr_info.guaspecialstate is '';
comment on column ${iol_schema}.icms_clr_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_info.etl_timestamp is 'ETL处理时间戳';
