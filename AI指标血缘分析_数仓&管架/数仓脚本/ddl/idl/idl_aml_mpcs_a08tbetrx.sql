/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_mpcs_a08tbetrx
CreateDate: 20250110
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.aml_mpcs_a08tbetrx purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.aml_mpcs_a08tbetrx(
etl_dt date --数据日期
,mainsq varchar2(40) --支付报单号(中台流水号)
,transdt varchar2(8) --交易日期
,opersq varchar2(16) --支付交易序号（行外），明细标识号
,businesstrace varchar2(40) --行内业务序号
,bustype varchar2(9) --业务类型
,servtype varchar2(18) --业务种类
,dtlcmtno varchar2(6) --业务要素集
,transseq varchar2(40) --包序号
,pkcodt varchar2(8) --包委托日期
,pktype varchar2(30) --包类型
,hosttrcd varchar2(30) --主机交易码
,fronttrcd varchar2(23) --中台交易码
,consigndt varchar2(8) --委托日期
,hostdate varchar2(8) --主机日期
,hostnbr varchar2(96) --主机流水
,crcycd varchar2(3) --币种
,transamt varchar2(26) --交易金额
,paybrn varchar2(14) --付款人开户行部门号
,payopenbrn varchar2(21) --付款人开户行行
,payacct varchar2(35) --付款人账号
,payname varchar2(180) --付款人名称
,payaddr varchar2(210) --付款人地址
,incobrn varchar2(14) --收款人开户行行号
,incoacct varchar2(35) --收款人账号
,inconame varchar2(180) --收款人名称
,incoaddr varchar2(210) --收款人地址
,sndct varchar2(6) --发报中心
,sndupbrn varchar2(14) --发起清算行行号
,sndbrn varchar2(14) --发起行行号
,rcvct varchar2(6) --收报中心
,rcvupbrn varchar2(14) --接收清算行行号
,rcvbrn varchar2(14) --接收行行号
,billdt varchar2(8) --原(包)委托日期
,billcd varchar2(16) --原支付交易序号
,orabustype varchar2(8) --原业务类型编码
,ptrasq varchar2(20) --票据号码
,obaltp varchar2(3) --轧差节点类型
,obalod varchar2(3) --轧差场次
,obaldt varchar2(8) --轧差日期/终态日期
,caclrs varchar2(20) --退汇原因代码
,cmpsam varchar2(26) --赔偿金金额、拆借利息、出票金额
,inrate varchar2(26) --利率
,refuam varchar2(26) --拒付金额
,transt varchar2(3) --处理状态
,processcode varchar2(6) --人行业务状态
,advest varchar2(30) --回执码
,vrseal varchar2(30) --处理代码(一般为人行返回码)
,ckrvno varchar2(15) --复核冲正流水号
,rndday varchar2(5) --回执期限
,retudt varchar2(8) --回执日期
,sdrvno varchar2(16) --发送冲正流水号
,clerdt varchar2(8) --清算日期
,bperno varchar2(30) --错误代码
,bpermg varchar2(450) --错误信息
,levels varchar2(26) --优先级别
,oprtlr varchar2(15) --录入柜员
,chktlr varchar2(15) --复核柜员
,sndtlr varchar2(15) --发送柜员
,auttlr varchar2(15) --授权柜员
,stptlr varchar2(12) --滞留柜员
,oprbrn varchar2(6) --录入复核柜员部门号
,sendbranch varchar2(6) --发送柜员部门号
,autbrn varchar2(6) --授权柜员部门号
,recdes varchar2(60) --支付密押
,chksta varchar2(3) --对账状态
,remark varchar2(768) --附言
,protocolnb varchar2(300) --提示付款日期、协议号
,prtcnt number(22) --打印次数
,recvdt varchar2(14) --收到时间
,transmitdt varchar2(14) --发送时间、转发时间
,blsecd varchar2(15) --
,paydat varchar2(8) --提示付款日期
,iotype varchar2(1) --往来帐标志
,flag2 varchar2(1) --实时联机标记
,flag3 varchar2(1) --收费标志
,flag4 varchar2(1) --借贷标记
,inoutflag varchar2(1) --行内行外标志
,blrqno varchar2(16) --汇票申请书号码
,sacact varchar2(35) --挂帐帐号或维护入账帐号
,sacana varchar2(180) --挂帐帐号或维护入账姓名
,clendt varchar2(8) --维护入账日期
,clenus varchar2(32) --维护入账柜员
,clrbrn varchar2(21) --维护入账部门号
,clract varchar2(32) --清分入帐帐号
,clrseq varchar2(72) --清分流水
,prdnbr varchar2(18) --代理标识 0 本行业务 1 代理他行
,tranbr varchar2(35) --日志流水号
,sdtrno varchar2(30) --发送日志流水
,bkcode varchar2(6) --凭证类型
,cobkdt varchar2(8) --委托凭证日期
,cobkcd varchar2(40) --委托凭证号
,idtype varchar2(15) --证件种类
,idno varchar2(30) --证件号码
,mxtram varchar2(26) --转帐限额
,transq varchar2(20) --交易流水套号
,sdtrsq varchar2(30) --发送交易流水
,paymod varchar2(1) --支付方式
,opnwin varchar2(12) --汇兑业务对应的窗口(交易渠道)
,chngdt varchar2(8) --最近修改日期
,bepssq varchar2(40) --业务流水号
,linkid number(22) --ID号
,feamt1 varchar2(26) --手续费
,feamt2 varchar2(26) --汇划费
,feamt3 varchar2(26) --工本费
,feamt4 varchar2(26) --费用（备用）
,priamt varchar2(26) --原托金额
,payamt varchar2(26) --支付金额
,spiamt varchar2(26) --多付金额
,edhtno varchar2(96) --取消交易流水
,edhtdt varchar2(8) --取消交易日期
,endtlr varchar2(12) --取消柜员
,chngti varchar2(14) --最近修改时间
,magbrn varchar2(12) --处理机构
,resv40 varchar2(60) --特殊码
,rcdver number(22) --记录更新版本号
,rcdsta varchar2(1) --记录状态
,prpktp varchar2(30) --原包类型
,prclbk varchar2(21) --原包发起清算行
,prpkdt varchar2(8) --原包委托日期
,prpksq varchar2(16) --原包序号
,prodcd varchar2(8) --产品代码
,isinout varchar2(1) --客户帐、内部帐标识
,inacct varchar2(35) --实际扣帐账号
,inname varchar2(180) --实际扣帐户名
,ourcnapsver varchar2(3) --行内系统版本
,othercnapsver varchar2(3) --对手系统版本
,landdealsts varchar2(3) --落地处理状态
,checkdealsts varchar2(3) --查证处理状态
,appenddatatable varchar2(45) --登记附加数据的表名
,appenddatadtltab varchar2(45) --登记附加数据明细的表名
,hangupreason varchar2(3) --挂账原因
,pkgbusinesstrace varchar2(16) --包行内序号
,pktype2 varchar2(20) --二代报文号
,bustype2 varchar2(9) --二代业务类型
,servtype2 varchar2(18) --二代业务种类
,payopenbanknm varchar2(210) --付款人开户行名称
,recvopenbanknm varchar2(210) --收款人开户行名称
,modifytlr varchar2(15) --修改柜员
,feetype varchar2(3) --收费方式
,eaccflg varchar2(1) --电子账户标志
,od_flag varchar2(1) --是否触发透支业务
,od_ovtranam number(18,2) --透支金额
,nextdayflag varchar2(1) --次日转账标识
,autoflag varchar2(1) --自动退汇处理标识
,autocount varchar2(1) --自动退汇处理次数
,automsg varchar2(300) --自动退汇处理信息
,bindacct varchar2(53) --绑定账户
,bindacctnm varchar2(180) --绑定账户名
,accttype varchar2(30) --账户类型
,bindacctopnbrn varchar2(12) --绑定账户开户机构
,lsttranst varchar2(3) --上一交易状态
,tacctp varchar2(30) --账户分类标识
,limitorderid varchar2(32) --限额订单号
,isbindcard varchar2(3) --绑定标志
,globalseqno varchar2(96) --全局流水号
,returncode varchar2(30) --ESB接口返回码
,returnmsg varchar2(1536) --ESB接口返回信息
,transseqno varchar2(60) --ESB接口交易流水号
,sendouttm varchar2(14) --发送人行时间
,unique_seq_num varchar2(64) --业务流水号(交易订单号)
,etl_timestamp timestamp(6) --任务处理时间

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_mpcs_a08tbetrx to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_mpcs_a08tbetrx is '小额交易流水表';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.mainsq is '支付报单号(中台流水号)';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.transdt is '交易日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.opersq is '支付交易序号（行外），明细标识号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.businesstrace is '行内业务序号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.bustype is '业务类型';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.servtype is '业务种类';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.dtlcmtno is '业务要素集';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.transseq is '包序号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.pkcodt is '包委托日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.pktype is '包类型';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.hosttrcd is '主机交易码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.fronttrcd is '中台交易码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.consigndt is '委托日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.hostdate is '主机日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.hostnbr is '主机流水';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.crcycd is '币种';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.transamt is '交易金额';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.paybrn is '付款人开户行部门号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.payopenbrn is '付款人开户行行';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.payacct is '付款人账号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.payname is '付款人名称';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.payaddr is '付款人地址';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.incobrn is '收款人开户行行号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.incoacct is '收款人账号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.inconame is '收款人名称';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.incoaddr is '收款人地址';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sndct is '发报中心';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sndupbrn is '发起清算行行号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sndbrn is '发起行行号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.rcvct is '收报中心';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.rcvupbrn is '接收清算行行号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.rcvbrn is '接收行行号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.billdt is '原(包)委托日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.billcd is '原支付交易序号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.orabustype is '原业务类型编码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.ptrasq is '票据号码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.obaltp is '轧差节点类型';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.obalod is '轧差场次';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.obaldt is '轧差日期/终态日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.caclrs is '退汇原因代码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.cmpsam is '赔偿金金额、拆借利息、出票金额';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.inrate is '利率';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.refuam is '拒付金额';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.transt is '处理状态';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.processcode is '人行业务状态';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.advest is '回执码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.vrseal is '处理代码(一般为人行返回码)';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.ckrvno is '复核冲正流水号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.rndday is '回执期限';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.retudt is '回执日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sdrvno is '发送冲正流水号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.clerdt is '清算日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.bperno is '错误代码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.bpermg is '错误信息';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.levels is '优先级别';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.oprtlr is '录入柜员';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.chktlr is '复核柜员';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sndtlr is '发送柜员';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.auttlr is '授权柜员';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.stptlr is '滞留柜员';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.oprbrn is '录入复核柜员部门号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sendbranch is '发送柜员部门号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.autbrn is '授权柜员部门号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.recdes is '支付密押';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.chksta is '对账状态';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.remark is '附言';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.protocolnb is '提示付款日期、协议号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.prtcnt is '打印次数';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.recvdt is '收到时间';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.transmitdt is '发送时间、转发时间';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.blsecd is '';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.paydat is '提示付款日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.iotype is '往来帐标志';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.flag2 is '实时联机标记';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.flag3 is '收费标志';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.flag4 is '借贷标记';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.inoutflag is '行内行外标志';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.blrqno is '汇票申请书号码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sacact is '挂帐帐号或维护入账帐号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sacana is '挂帐帐号或维护入账姓名';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.clendt is '维护入账日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.clenus is '维护入账柜员';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.clrbrn is '维护入账部门号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.clract is '清分入帐帐号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.clrseq is '清分流水';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.prdnbr is '代理标识 0 本行业务 1 代理他行';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.tranbr is '日志流水号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sdtrno is '发送日志流水';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.bkcode is '凭证类型';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.cobkdt is '委托凭证日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.cobkcd is '委托凭证号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.idtype is '证件种类';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.idno is '证件号码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.mxtram is '转帐限额';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.transq is '交易流水套号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sdtrsq is '发送交易流水';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.paymod is '支付方式';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.opnwin is '汇兑业务对应的窗口(交易渠道)';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.chngdt is '最近修改日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.bepssq is '业务流水号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.linkid is 'ID号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.feamt1 is '手续费';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.feamt2 is '汇划费';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.feamt3 is '工本费';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.feamt4 is '费用（备用）';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.priamt is '原托金额';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.payamt is '支付金额';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.spiamt is '多付金额';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.edhtno is '取消交易流水';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.edhtdt is '取消交易日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.endtlr is '取消柜员';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.chngti is '最近修改时间';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.magbrn is '处理机构';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.resv40 is '特殊码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.rcdver is '记录更新版本号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.rcdsta is '记录状态';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.prpktp is '原包类型';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.prclbk is '原包发起清算行';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.prpkdt is '原包委托日期';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.prpksq is '原包序号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.prodcd is '产品代码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.isinout is '客户帐、内部帐标识';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.inacct is '实际扣帐账号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.inname is '实际扣帐户名';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.ourcnapsver is '行内系统版本';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.othercnapsver is '对手系统版本';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.landdealsts is '落地处理状态';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.checkdealsts is '查证处理状态';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.appenddatatable is '登记附加数据的表名';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.appenddatadtltab is '登记附加数据明细的表名';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.hangupreason is '挂账原因';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.pkgbusinesstrace is '包行内序号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.pktype2 is '二代报文号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.bustype2 is '二代业务类型';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.servtype2 is '二代业务种类';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.payopenbanknm is '付款人开户行名称';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.recvopenbanknm is '收款人开户行名称';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.modifytlr is '修改柜员';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.feetype is '收费方式';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.eaccflg is '电子账户标志';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.od_flag is '是否触发透支业务';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.od_ovtranam is '透支金额';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.nextdayflag is '次日转账标识';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.autoflag is '自动退汇处理标识';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.autocount is '自动退汇处理次数';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.automsg is '自动退汇处理信息';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.bindacct is '绑定账户';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.bindacctnm is '绑定账户名';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.accttype is '账户类型';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.bindacctopnbrn is '绑定账户开户机构';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.lsttranst is '上一交易状态';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.tacctp is '账户分类标识';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.limitorderid is '限额订单号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.isbindcard is '绑定标志';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.globalseqno is '全局流水号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.returncode is 'ESB接口返回码';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.returnmsg is 'ESB接口返回信息';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.transseqno is 'ESB接口交易流水号';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.sendouttm is '发送人行时间';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.unique_seq_num is '业务流水号(交易订单号)';
comment on column ${idl_schema}.aml_mpcs_a08tbetrx.etl_timestamp is '任务处理时间';

