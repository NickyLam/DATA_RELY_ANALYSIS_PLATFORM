/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_mpcs_a68tszfstrx
CreateDate: 20221228
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.aml_mpcs_a68tszfstrx purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.aml_mpcs_a68tszfstrx(
etl_dt date --数据日期
,mainseq varchar2(16) --行内中台流水号
,transdt varchar2(8) --交易日期
,businesstrace varchar2(16) --行内业务序号
,pckno varchar2(20) --报文类型
,txtpcd varchar2(3) --业务类型
,txcd varchar2(5) --业务编号
,txid varchar2(8) --支付交易序号，明细标识号
,cnsdt varchar2(8) --委托日期，明细的委托日期
,instgpty varchar2(14) --委托方
,pkgbusinesstrace varchar2(16) --所属批量包业务序号
,pksqno varchar2(16) --包序号
,hosttrcd varchar2(20) --
,fronttrcd varchar2(15) --中台交易码
,hostdate varchar2(8) --主机日期
,hostnbr varchar2(64) --
,crcycd varchar2(3) --币种
,transamt varchar2(17) --交易金额
,dbtrid varchar2(14) --付款行行号
,sndbrnname varchar2(140) --付款行行名
,cdtrid varchar2(14) --收款行行号
,rcvbrnname varchar2(140) --收款行行名
,payopenbank varchar2(14) --付款人开户行行号
,payopenbanknm varchar2(140) --付款人开户行名称
,payacct varchar2(35) --付款人账号
,payname varchar2(120) --付款人名称
,payaddr varchar2(140) --付款人地址
,rcvopenbank varchar2(14) --收款人开户行行号
,rcvopenbanknm varchar2(140) --收款人开户行名称
,rcvacct varchar2(35) --收款人账号
,rcvname varchar2(120) --收款人名称
,rcvaddr varchar2(140) --收款人地址
,orgnltxtpcd varchar2(3) --原业务类型
,orgnlcnsdt varchar2(8) --原委托日期
,orgnltxid varchar2(8) --原支付交易序号
,orgnlinstgpty varchar2(14) --原委托方
,orgnlpkgbustrace varchar2(16) --原所属包业务序号
,netgrnd number(22) --轧差场次
,netgdt varchar2(8) --轧差日期/终态日期
,transt varchar2(2) --处理状态
,iotype varchar2(1) --往来账标识
,flag4 varchar2(1) --借贷标志
,magebrn varchar2(8) --处理机构
,oprtlr varchar2(10) --
,chktlr varchar2(10) --
,sndtlr varchar2(10) --
,auttlr varchar2(10) --
,oprbrn varchar2(6) --录入复核柜员部门号
,sendbranch varchar2(6) --发送柜员部门号
,autbrn varchar2(6) --授权柜员部门号
,caclrs varchar2(20) --退汇原因代码
,processcode varchar2(4) --中心返回状态
,rspncd varchar2(8) --中心返回处理码
,rspninf varchar2(120) --中心返回处理码处理说明
,rtncd varchar2(500) --
,rtninf varchar2(120) --银行返回处理码处理说明
,rtrltd varchar2(8) --回执日期
,diskno varchar2(16) --定期业务批次号
,clerdt varchar2(8) --清算日期
,bperno varchar2(15) --
,bpermg varchar2(400) --
,levels varchar2(17) --优先级别
,recdes varchar2(40) --支付密押
,chksta varchar2(2) --对账状态
,remark varchar2(500) --附言
,prtcnt number(22) --打印次数
,transmitdt varchar2(14) --往账：发送时间、转发时间 来账：收到时间
,feeflag varchar2(1) --收费标志
,inoutflag varchar2(1) --行内行外标志    0行外  1行内
,sacact varchar2(35) --挂帐帐号或维护入账帐号
,sacana varchar2(120) --挂帐帐号或维护入账姓名
,clendt varchar2(8) --维护入账日期
,clenus varchar2(21) --维护入账柜员
,clrbrn varchar2(21) --维护入账部门号
,edhtno varchar2(64) --
,edhtdt varchar2(8) --维护入账主机日期/维护入账冲账主机日期
,endtlr varchar2(8) --维护入账冲账柜员号
,prdnbr varchar2(12) --代理标识 0 本行业务 1 代理他行
,bookcd varchar2(4) --凭证类型
,cobkdt varchar2(8) --委托凭证日期
,booknbr varchar2(20) --委托凭证号
,idtype varchar2(4) --
,idno varchar2(30) --证件号码
,transq varchar2(20) --交易流水套号
,sdtrsq varchar2(20) --发送交易流水
,paymod varchar2(1) --支付方式
,opnwin varchar2(8) --汇兑业务对应的窗口(交易渠道)
,feamt1 varchar2(17) --手续费
,feamt2 varchar2(17) --汇划费
,feamt3 varchar2(17) --工本费
,calfee varchar2(17) --手续费总额
,chngti varchar2(14) --最近修改时间
,rcdsta varchar2(1) --记录状态
,prodcd varchar2(8) --产品代码
,isinout varchar2(1) --客户帐、内部帐标识 
,inacct varchar2(35) --实际扣帐账号
,inname varchar2(100) --实际扣帐户名
,landdealsts varchar2(2) --落地处理状态
,checkdealsts varchar2(2) --查证处理状态
,appenddatatable varchar2(30) --登记附加数据的表名
,appenddatadtltab varchar2(30) --登记附加数据明细的表名
,hangupreason varchar2(2) --挂账原因
,modifytlr varchar2(10) --
,feetype varchar2(2) --计费种类
,areacd varchar2(8) --地区代码
,acctchckflg varchar2(1) --帐户信息检查标志
,servmode varchar2(1) --业务类型(0-转账 1-现金)
,realtmcdtflg varchar2(1) --实时贷记实时入账标志(0允许落地处理 1不允许)
,chflag varchar2(1) --钞汇标志
,protocolnb varchar2(60) --定期借贷记协议号（明细）
,resndflg varchar2(1) --补发标识(0正常 1补发)
,bllind varchar2(1) --票据标志
,blltp varchar2(1) --票据种类
,billnb varchar2(32) --票据号码
,channeldt varchar2(8) --渠道日期
,tranflowno varchar2(64) --渠道流水号
,orgnlpksqno varchar2(16) --原业务包序号
,corprtnid varchar2(14) --企业单位代码
,pmtitmcd varchar2(5) --费项代码
,pmtitmnm varchar2(24) --费项名称
,billamount varchar2(17) --业务金额
,feeamount varchar2(17) --需付款行代扣的手续费
,info2 varchar2(500) --冲账原因
,od_flag varchar2(1) --是否发生透支 0- 否 1- 是
,od_ovtranam number(18,2) --透支金额
,toaccountflag varchar2(2) --0：不延时 1：延时2小时 2：次日到账 3：延时24小时
,autoflag varchar2(1) --自动退汇标志 1-自动退汇
,autocount varchar2(1) --自动退汇次数
,automsg varchar2(200) --自动退汇信息
,bindacct varchar2(35) --绑定账户(实体账户)
,bindacctnm varchar2(200) --绑定账户名(实体账户名)
,eflag varchar2(1) --1个人e 2企业e
,upporderid varchar2(64) --UPP返回订单标识
,intoaccounttype varchar2(100) --实际收款人账号类型
,accttype varchar2(20) --账户类型 EDME-存管+账户 QSTP-广清所
,bindacctopnbrn varchar2(8) --虚拟账户绑定的账户开户机构
,branchid varchar2(8) --开户机构
,tacctp varchar2(20) --账户类别
,handleflag varchar2(2) --后续操作标志
,custno varchar2(30) --客户号
,pmtid varchar2(30) --协议号
,etl_timestamp timestamp(6) -- 任务处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_mpcs_a68tszfstrx to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_mpcs_a68tszfstrx is '深同城交易流水表';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.mainseq is '行内中台流水号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.transdt is '交易日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.businesstrace is '行内业务序号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.pckno is '报文类型';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.txtpcd is '业务类型';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.txcd is '业务编号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.txid is '支付交易序号，明细标识号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.cnsdt is '委托日期，明细的委托日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.instgpty is '委托方';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.pkgbusinesstrace is '所属批量包业务序号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.pksqno is '包序号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.hosttrcd is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.fronttrcd is '中台交易码';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.hostdate is '主机日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.hostnbr is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.crcycd is '币种';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.transamt is '交易金额';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.dbtrid is '付款行行号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.sndbrnname is '付款行行名';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.cdtrid is '收款行行号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rcvbrnname is '收款行行名';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.payopenbank is '付款人开户行行号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.payopenbanknm is '付款人开户行名称';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.payacct is '付款人账号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.payname is '付款人名称';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.payaddr is '付款人地址';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rcvopenbank is '收款人开户行行号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rcvopenbanknm is '收款人开户行名称';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rcvacct is '收款人账号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rcvname is '收款人名称';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rcvaddr is '收款人地址';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.orgnltxtpcd is '原业务类型';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.orgnlcnsdt is '原委托日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.orgnltxid is '原支付交易序号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.orgnlinstgpty is '原委托方';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.orgnlpkgbustrace is '原所属包业务序号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.netgrnd is '轧差场次';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.netgdt is '轧差日期/终态日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.transt is '处理状态';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.iotype is '往来账标识';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.flag4 is '借贷标志';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.magebrn is '处理机构';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.oprtlr is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.chktlr is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.sndtlr is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.auttlr is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.oprbrn is '录入复核柜员部门号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.sendbranch is '发送柜员部门号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.autbrn is '授权柜员部门号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.caclrs is '退汇原因代码';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.processcode is '中心返回状态';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rspncd is '中心返回处理码';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rspninf is '中心返回处理码处理说明';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rtncd is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rtninf is '银行返回处理码处理说明';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rtrltd is '回执日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.diskno is '定期业务批次号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.clerdt is '清算日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.bperno is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.bpermg is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.levels is '优先级别';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.recdes is '支付密押';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.chksta is '对账状态';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.remark is '附言';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.prtcnt is '打印次数';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.transmitdt is '往账：发送时间、转发时间 来账：收到时间';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.feeflag is '收费标志';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.inoutflag is '行内行外标志    0行外  1行内';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.sacact is '挂帐帐号或维护入账帐号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.sacana is '挂帐帐号或维护入账姓名';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.clendt is '维护入账日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.clenus is '维护入账柜员';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.clrbrn is '维护入账部门号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.edhtno is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.edhtdt is '维护入账主机日期/维护入账冲账主机日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.endtlr is '维护入账冲账柜员号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.prdnbr is '代理标识 0 本行业务 1 代理他行';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.bookcd is '凭证类型';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.cobkdt is '委托凭证日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.booknbr is '委托凭证号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.idtype is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.idno is '证件号码';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.transq is '交易流水套号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.sdtrsq is '发送交易流水';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.paymod is '支付方式';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.opnwin is '汇兑业务对应的窗口(交易渠道)';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.feamt1 is '手续费';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.feamt2 is '汇划费';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.feamt3 is '工本费';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.calfee is '手续费总额';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.chngti is '最近修改时间';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.rcdsta is '记录状态';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.prodcd is '产品代码';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.isinout is '客户帐、内部帐标识 ';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.inacct is '实际扣帐账号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.inname is '实际扣帐户名';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.landdealsts is '落地处理状态';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.checkdealsts is '查证处理状态';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.appenddatatable is '登记附加数据的表名';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.appenddatadtltab is '登记附加数据明细的表名';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.hangupreason is '挂账原因';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.modifytlr is '';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.feetype is '计费种类';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.areacd is '地区代码';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.acctchckflg is '帐户信息检查标志';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.servmode is '业务类型(0-转账 1-现金)';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.realtmcdtflg is '实时贷记实时入账标志(0允许落地处理 1不允许)';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.chflag is '钞汇标志';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.protocolnb is '定期借贷记协议号（明细）';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.resndflg is '补发标识(0正常 1补发)';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.bllind is '票据标志';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.blltp is '票据种类';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.billnb is '票据号码';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.channeldt is '渠道日期';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.tranflowno is '渠道流水号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.orgnlpksqno is '原业务包序号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.corprtnid is '企业单位代码';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.pmtitmcd is '费项代码';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.pmtitmnm is '费项名称';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.billamount is '业务金额';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.feeamount is '需付款行代扣的手续费';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.info2 is '冲账原因';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.od_flag is '是否发生透支 0- 否 1- 是';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.od_ovtranam is '透支金额';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.toaccountflag is '0：不延时 1：延时2小时 2：次日到账 3：延时24小时';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.autoflag is '自动退汇标志 1-自动退汇';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.autocount is '自动退汇次数';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.automsg is '自动退汇信息';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.bindacct is '绑定账户(实体账户)';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.bindacctnm is '绑定账户名(实体账户名)';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.eflag is '1个人e 2企业e';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.upporderid is 'UPP返回订单标识';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.intoaccounttype is '实际收款人账号类型';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.accttype is '账户类型 EDME-存管+账户 QSTP-广清所';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.bindacctopnbrn is '虚拟账户绑定的账户开户机构';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.branchid is '开户机构';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.tacctp is '账户类别';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.handleflag is '后续操作标志';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.custno is '客户号';
comment on column ${idl_schema}.aml_mpcs_a68tszfstrx.pmtid is '协议号';

