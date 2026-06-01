/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mpcs_a08tbetrx
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.mpcs_a08tbetrx drop partition p_${last_date};
alter table ${idl_schema}.mpcs_a08tbetrx drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.mpcs_a08tbetrx add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.mpcs_a08tbetrx (
    mainsq                         --支付报单号(中台流水号)
    ,opersq                        --支付交易序号（行外），明细标识号
    ,businesstrace                 --行内业务序号
    ,bustype                       --业务类型
    ,servtype                      --业务种类
    ,dtlcmtno                      --业务要素集
    ,transseq                      --包序号
    ,pkcodt                        --包委托日期
    ,pktype                        --包类型
    ,hosttrcd                      --主机交易码
    ,fronttrcd                     --中台交易码
    ,transdt                       --交易日期
    ,consigndt                     --委托日期
    ,hostdate                      --主机日期
    ,hostnbr                       --主机流水
    ,crcycd                        --币种
    ,transamt                      --交易金额
    ,paybrn                        --付款人开户行部门号
    ,payopenbrn                    --付款人开户行行
    ,payacct                       --付款人账号
    ,payname                       --付款人名称
    ,payaddr                       --付款人地址
    ,incobrn                       --收款人开户行行号
    ,incoacct                      --收款人账号
    ,inconame                      --收款人名称
    ,incoaddr                      --收款人地址
    ,sndct                         --发报中心
    ,sndupbrn                      --发起清算行行号
    ,sndbrn                        --发起行行号
    ,rcvct                         --收报中心
    ,rcvupbrn                      --接收清算行行号
    ,rcvbrn                        --接收行行号
    ,billdt                        --原(包)委托日期
    ,billcd                        --原支付交易序号
    ,orabustype                    --原业务类型编码
    ,ptrasq                        --票据号码
    ,obaltp                        --轧差节点类型
    ,obalod                        --轧差场次
    ,obaldt                        --轧差日期/终态日期
    ,caclrs                        --退汇原因代码
    ,cmpsam                        --赔偿金金额、拆借利息、出票金额
    ,inrate                        --利率
    ,refuam                        --拒付金额
    ,transt                        --处理状态
    ,processcode                   --人行业务状态
    ,advest                        --回执码
    ,vrseal                        --处理代码(一般为人行返回码)
    ,ckrvno                        --复核冲正流水号
    ,rndday                        --回执期限
    ,retudt                        --回执日期
    ,sdrvno                        --发送冲正流水号
    ,clerdt                        --清算日期
    ,bperno                        --错误代码
    ,bpermg                        --错误信息
    ,levels                        --优先级别
    ,oprtlr                        --录入柜员
    ,chktlr                        --复核柜员
    ,sndtlr                        --发送柜员
    ,auttlr                        --授权柜员
    ,stptlr                        --滞留柜员
    ,oprbrn                        --录入复核柜员部门号
    ,sendbranch                    --发送柜员部门号
    ,autbrn                        --授权柜员部门号
    ,recdes                        --支付密押
    ,chksta                        --对账状态
    ,remark                        --附言
    ,protocolnb                    --提示付款日期、协议号
    ,prtcnt                        --打印次数
    ,recvdt                        --收到时间
    ,transmitdt                    --发送时间、转发时间
    ,blsecd                        --
    ,paydat                        --提示付款日期
    ,iotype                        --往来帐标志
    ,flag2                         --实时联机标记
    ,flag3                         --收费标志
    ,flag4                         --借贷标记
    ,inoutflag                     --行内行外标志
    ,blrqno                        --汇票申请书号码
    ,sacact                        --挂帐帐号或维护入账帐号
    ,sacana                        --挂帐帐号或维护入账姓名
    ,clendt                        --维护入账日期
    ,clenus                        --维护入账柜员
    ,clrbrn                        --维护入账部门号
    ,clract                        --清分入帐帐号
    ,clrseq                        --清分流水
    ,prdnbr                        --01代理他行
    ,tranbr                        --日志流水号
    ,sdtrno                        --发送日志流水
    ,bkcode                        --凭证类型
    ,cobkdt                        --委托凭证日期
    ,cobkcd                        --委托凭证号
    ,idtype                        --证件种类
    ,idno                          --证件号码
    ,mxtram                        --转帐限额
    ,transq                        --交易流水套号
    ,sdtrsq                        --发送交易流水
    ,paymod                        --支付方式
    ,opnwin                        --汇兑业务对应的窗口(交易渠道)
    ,chngdt                        --最近修改日期
    ,bepssq                        --业务流水号
    ,linkid                        --ID号
    ,feamt1                        --手续费
    ,feamt2                        --汇划费
    ,feamt3                        --工本费
    ,feamt4                        --费用（备用）
    ,priamt                        --原托金额
    ,payamt                        --支付金额
    ,spiamt                        --多付金额
    ,edhtno                        --取消交易流水
    ,edhtdt                        --取消交易日期
    ,endtlr                        --取消柜员
    ,chngti                        --最近修改时间
    ,magbrn                        --处理机构
    ,resv40                        --特殊码
    ,rcdver                        --记录更新版本号
    ,rcdsta                        --记录状态
    ,prpktp                        --原包类型
    ,prclbk                        --原包发起清算行
    ,prpkdt                        --原包委托日期
    ,prpksq                        --原包序号
    ,prodcd                        --产品代码
    ,isinout                       --客户帐、内部帐标识
    ,inacct                        --实际扣帐账号
    ,inname                        --实际扣帐户名
    ,ourcnapsver                   --行内系统版本
    ,othercnapsver                 --对手系统版本
    ,landdealsts                   --落地处理状态
    ,checkdealsts                  --查证处理状态
    ,appenddatatable               --登记附加数据的表名
    ,appenddatadtltab              --登记附加数据明细的表名
    ,hangupreason                  --挂账原因
    ,pkgbusinesstrace              --包行内序号
    ,pktype2                       --二代报文号
    ,bustype2                      --二代业务类型
    ,servtype2                     --二代业务种类
    ,payopenbanknm                 --付款人开户行名称
    ,recvopenbanknm                --收款人开户行名称
    ,modifytlr                     --修改柜员
    ,feetype                       --收费方式
    ,eaccflg                       --电子账户标志
    ,od_flag                       --是否触发透支业务
    ,od_ovtranam                   --透支金额
    ,nextdayflag                   --次日转账标识
    ,autoflag                      --自动退汇处理标识
    ,autocount                     --自动退汇处理次数
    ,automsg                       --自动退汇处理信息
    ,bindacct                      --绑定账户
    ,bindacctnm                    --绑定账户名
    ,accttype                      --账户类型
    ,bindacctopnbrn                --绑定账户开户机构
    ,lsttranst                     --上一交易状态
    ,tacctp                        --账户分类标识
    ,limitorderid                  --限额订单号
    ,isbindcard                    --绑定标志
    ,globalseqno                   --全局流水号
    ,returncode                    --ESB接口返回码
    ,returnmsg                     --ESB接口返回信息
    ,transseqno                    --ESB接口交易流水号
    ,sendouttm                     --发送人行时间
    ,finaccountid                  --e账户时需要
    ,acct_typ_id                   --ppp账户类型
    ,memocntt                      --摘要码
    ,acctchngflg                   --接收方动账标识
    ,tagrmt                        --收付款通知编号
    ,cdtrfiacctfg                  --收款方金融账户标识
    ,inersettleacct                --内部结算账号(收付款)
    ,inersettlename                --内部结算名称(收付款)
    ,unisoccdtcd                   --统一社会信用代码
    ,regid                         --地域标识
    ,splchrgsreqtpcd               --特约委收种类代码
    ,trnsmtdt                      --转发日期(用于计算回执日期)
    ,payupbrn                      --付款清算行
    ,incoupbrn                     --收款清算行
    ,agtflg                        --是否代理
    ,agtidtp                       --代理人证件类型
    ,agtidno                       --代理人证件号码
    ,agtname                       --代理人姓名
    ,agtphone                      --代理人联系方式
    ,budgetary                     --预算级次
    ,exchgflg                      --个人汇兑标识
    ,orisrcsysssn                  --原交易流水
    ,orisyscd                      --原支付通道
    ,redoflag                      --重发标志
    ,etl_dt                        --ETL处理日期
    ,etl_timestamp                 --ETL处理时间戳
)
select 
    replace(replace(t1.mainsq,chr(13),''),chr(10),'') as mainsq 
    ,replace(replace(t1.opersq,chr(13),''),chr(10),'') as opersq 
    ,replace(replace(t1.businesstrace,chr(13),''),chr(10),'') as businesstrace 
    ,replace(replace(t1.bustype,chr(13),''),chr(10),'') as bustype 
    ,replace(replace(t1.servtype,chr(13),''),chr(10),'') as servtype 
    ,replace(replace(t1.dtlcmtno,chr(13),''),chr(10),'') as dtlcmtno 
    ,replace(replace(t1.transseq,chr(13),''),chr(10),'') as transseq 
    ,replace(replace(t1.pkcodt,chr(13),''),chr(10),'') as pkcodt 
    ,replace(replace(t1.pktype,chr(13),''),chr(10),'') as pktype 
    ,replace(replace(t1.hosttrcd,chr(13),''),chr(10),'') as hosttrcd 
    ,replace(replace(t1.fronttrcd,chr(13),''),chr(10),'') as fronttrcd 
    ,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt 
    ,replace(replace(t1.consigndt,chr(13),''),chr(10),'') as consigndt 
    ,replace(replace(t1.hostdate,chr(13),''),chr(10),'') as hostdate 
    ,replace(replace(t1.hostnbr,chr(13),''),chr(10),'') as hostnbr 
    ,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd 
    ,replace(replace(t1.transamt,chr(13),''),chr(10),'') as transamt 
    ,replace(replace(t1.paybrn,chr(13),''),chr(10),'') as paybrn 
    ,replace(replace(t1.payopenbrn,chr(13),''),chr(10),'') as payopenbrn 
    ,replace(replace(t1.payacct,chr(13),''),chr(10),'') as payacct 
    ,replace(replace(t1.payname,chr(13),''),chr(10),'') as payname 
    ,replace(replace(t1.payaddr,chr(13),''),chr(10),'') as payaddr 
    ,replace(replace(t1.incobrn,chr(13),''),chr(10),'') as incobrn 
    ,replace(replace(t1.incoacct,chr(13),''),chr(10),'') as incoacct 
    ,replace(replace(t1.inconame,chr(13),''),chr(10),'') as inconame 
    ,replace(replace(t1.incoaddr,chr(13),''),chr(10),'') as incoaddr 
    ,replace(replace(t1.sndct,chr(13),''),chr(10),'') as sndct 
    ,replace(replace(t1.sndupbrn,chr(13),''),chr(10),'') as sndupbrn 
    ,replace(replace(t1.sndbrn,chr(13),''),chr(10),'') as sndbrn 
    ,replace(replace(t1.rcvct,chr(13),''),chr(10),'') as rcvct 
    ,replace(replace(t1.rcvupbrn,chr(13),''),chr(10),'') as rcvupbrn 
    ,replace(replace(t1.rcvbrn,chr(13),''),chr(10),'') as rcvbrn 
    ,replace(replace(t1.billdt,chr(13),''),chr(10),'') as billdt 
    ,replace(replace(t1.billcd,chr(13),''),chr(10),'') as billcd 
    ,replace(replace(t1.orabustype,chr(13),''),chr(10),'') as orabustype 
    ,replace(replace(t1.ptrasq,chr(13),''),chr(10),'') as ptrasq 
    ,replace(replace(t1.obaltp,chr(13),''),chr(10),'') as obaltp 
    ,replace(replace(t1.obalod,chr(13),''),chr(10),'') as obalod 
    ,replace(replace(t1.obaldt,chr(13),''),chr(10),'') as obaldt 
    ,replace(replace(t1.caclrs,chr(13),''),chr(10),'') as caclrs 
    ,replace(replace(t1.cmpsam,chr(13),''),chr(10),'') as cmpsam 
    ,replace(replace(t1.inrate,chr(13),''),chr(10),'') as inrate 
    ,replace(replace(t1.refuam,chr(13),''),chr(10),'') as refuam 
    ,replace(replace(t1.transt,chr(13),''),chr(10),'') as transt 
    ,replace(replace(t1.processcode,chr(13),''),chr(10),'') as processcode 
    ,replace(replace(t1.advest,chr(13),''),chr(10),'') as advest 
    ,replace(replace(t1.vrseal,chr(13),''),chr(10),'') as vrseal 
    ,replace(replace(t1.ckrvno,chr(13),''),chr(10),'') as ckrvno 
    ,replace(replace(t1.rndday,chr(13),''),chr(10),'') as rndday 
    ,replace(replace(t1.retudt,chr(13),''),chr(10),'') as retudt 
    ,replace(replace(t1.sdrvno,chr(13),''),chr(10),'') as sdrvno 
    ,replace(replace(t1.clerdt,chr(13),''),chr(10),'') as clerdt 
    ,replace(replace(t1.bperno,chr(13),''),chr(10),'') as bperno 
    ,replace(replace(t1.bpermg,chr(13),''),chr(10),'') as bpermg 
    ,replace(replace(t1.levels,chr(13),''),chr(10),'') as levels 
    ,replace(replace(t1.oprtlr,chr(13),''),chr(10),'') as oprtlr 
    ,replace(replace(t1.chktlr,chr(13),''),chr(10),'') as chktlr 
    ,replace(replace(t1.sndtlr,chr(13),''),chr(10),'') as sndtlr 
    ,replace(replace(t1.auttlr,chr(13),''),chr(10),'') as auttlr 
    ,replace(replace(t1.stptlr,chr(13),''),chr(10),'') as stptlr 
    ,replace(replace(t1.oprbrn,chr(13),''),chr(10),'') as oprbrn 
    ,replace(replace(t1.sendbranch,chr(13),''),chr(10),'') as sendbranch 
    ,replace(replace(t1.autbrn,chr(13),''),chr(10),'') as autbrn 
    ,replace(replace(t1.recdes,chr(13),''),chr(10),'') as recdes 
    ,replace(replace(t1.chksta,chr(13),''),chr(10),'') as chksta 
    ,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark 
    ,replace(replace(t1.protocolnb,chr(13),''),chr(10),'') as protocolnb 
    ,t1.prtcnt as prtcnt 
    ,replace(replace(t1.recvdt,chr(13),''),chr(10),'') as recvdt 
    ,replace(replace(t1.transmitdt,chr(13),''),chr(10),'') as transmitdt 
    ,replace(replace(t1.blsecd,chr(13),''),chr(10),'') as blsecd 
    ,replace(replace(t1.paydat,chr(13),''),chr(10),'') as paydat 
    ,replace(replace(t1.iotype,chr(13),''),chr(10),'') as iotype 
    ,replace(replace(t1.flag2,chr(13),''),chr(10),'') as flag2 
    ,replace(replace(t1.flag3,chr(13),''),chr(10),'') as flag3 
    ,replace(replace(t1.flag4,chr(13),''),chr(10),'') as flag4 
    ,replace(replace(t1.inoutflag,chr(13),''),chr(10),'') as inoutflag 
    ,replace(replace(t1.blrqno,chr(13),''),chr(10),'') as blrqno 
    ,replace(replace(t1.sacact,chr(13),''),chr(10),'') as sacact 
    ,replace(replace(t1.sacana,chr(13),''),chr(10),'') as sacana 
    ,replace(replace(t1.clendt,chr(13),''),chr(10),'') as clendt 
    ,replace(replace(t1.clenus,chr(13),''),chr(10),'') as clenus 
    ,replace(replace(t1.clrbrn,chr(13),''),chr(10),'') as clrbrn 
    ,replace(replace(t1.clract,chr(13),''),chr(10),'') as clract 
    ,replace(replace(t1.clrseq,chr(13),''),chr(10),'') as clrseq 
    ,replace(replace(t1.prdnbr,chr(13),''),chr(10),'') as prdnbr 
    ,replace(replace(t1.tranbr,chr(13),''),chr(10),'') as tranbr 
    ,replace(replace(t1.sdtrno,chr(13),''),chr(10),'') as sdtrno 
    ,replace(replace(t1.bkcode,chr(13),''),chr(10),'') as bkcode 
    ,replace(replace(t1.cobkdt,chr(13),''),chr(10),'') as cobkdt 
    ,replace(replace(t1.cobkcd,chr(13),''),chr(10),'') as cobkcd 
    ,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype 
    ,replace(replace(t1.idno,chr(13),''),chr(10),'') as idno 
    ,replace(replace(t1.mxtram,chr(13),''),chr(10),'') as mxtram 
    ,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq 
    ,replace(replace(t1.sdtrsq,chr(13),''),chr(10),'') as sdtrsq 
    ,replace(replace(t1.paymod,chr(13),''),chr(10),'') as paymod 
    ,replace(replace(t1.opnwin,chr(13),''),chr(10),'') as opnwin 
    ,replace(replace(t1.chngdt,chr(13),''),chr(10),'') as chngdt 
    ,replace(replace(t1.bepssq,chr(13),''),chr(10),'') as bepssq 
    ,t1.linkid as linkid 
    ,replace(replace(t1.feamt1,chr(13),''),chr(10),'') as feamt1 
    ,replace(replace(t1.feamt2,chr(13),''),chr(10),'') as feamt2 
    ,replace(replace(t1.feamt3,chr(13),''),chr(10),'') as feamt3 
    ,replace(replace(t1.feamt4,chr(13),''),chr(10),'') as feamt4 
    ,replace(replace(t1.priamt,chr(13),''),chr(10),'') as priamt 
    ,replace(replace(t1.payamt,chr(13),''),chr(10),'') as payamt 
    ,replace(replace(t1.spiamt,chr(13),''),chr(10),'') as spiamt 
    ,replace(replace(t1.edhtno,chr(13),''),chr(10),'') as edhtno 
    ,replace(replace(t1.edhtdt,chr(13),''),chr(10),'') as edhtdt 
    ,replace(replace(t1.endtlr,chr(13),''),chr(10),'') as endtlr 
    ,replace(replace(t1.chngti,chr(13),''),chr(10),'') as chngti 
    ,replace(replace(t1.magbrn,chr(13),''),chr(10),'') as magbrn 
    ,replace(replace(t1.resv40,chr(13),''),chr(10),'') as resv40 
    ,t1.rcdver as rcdver 
    ,replace(replace(t1.rcdsta,chr(13),''),chr(10),'') as rcdsta 
    ,replace(replace(t1.prpktp,chr(13),''),chr(10),'') as prpktp 
    ,replace(replace(t1.prclbk,chr(13),''),chr(10),'') as prclbk 
    ,replace(replace(t1.prpkdt,chr(13),''),chr(10),'') as prpkdt 
    ,replace(replace(t1.prpksq,chr(13),''),chr(10),'') as prpksq 
    ,replace(replace(t1.prodcd,chr(13),''),chr(10),'') as prodcd 
    ,replace(replace(t1.isinout,chr(13),''),chr(10),'') as isinout 
    ,replace(replace(t1.inacct,chr(13),''),chr(10),'') as inacct 
    ,replace(replace(t1.inname,chr(13),''),chr(10),'') as inname 
    ,replace(replace(t1.ourcnapsver,chr(13),''),chr(10),'') as ourcnapsver 
    ,replace(replace(t1.othercnapsver,chr(13),''),chr(10),'') as othercnapsver 
    ,replace(replace(t1.landdealsts,chr(13),''),chr(10),'') as landdealsts 
    ,replace(replace(t1.checkdealsts,chr(13),''),chr(10),'') as checkdealsts 
    ,replace(replace(t1.appenddatatable,chr(13),''),chr(10),'') as appenddatatable 
    ,replace(replace(t1.appenddatadtltab,chr(13),''),chr(10),'') as appenddatadtltab 
    ,replace(replace(t1.hangupreason,chr(13),''),chr(10),'') as hangupreason 
    ,replace(replace(t1.pkgbusinesstrace,chr(13),''),chr(10),'') as pkgbusinesstrace 
    ,replace(replace(t1.pktype2,chr(13),''),chr(10),'') as pktype2 
    ,replace(replace(t1.bustype2,chr(13),''),chr(10),'') as bustype2 
    ,replace(replace(t1.servtype2,chr(13),''),chr(10),'') as servtype2 
    ,replace(replace(t1.payopenbanknm,chr(13),''),chr(10),'') as payopenbanknm 
    ,replace(replace(t1.recvopenbanknm,chr(13),''),chr(10),'') as recvopenbanknm 
    ,replace(replace(t1.modifytlr,chr(13),''),chr(10),'') as modifytlr 
    ,replace(replace(t1.feetype,chr(13),''),chr(10),'') as feetype 
    ,replace(replace(t1.eaccflg,chr(13),''),chr(10),'') as eaccflg 
    ,replace(replace(t1.od_flag,chr(13),''),chr(10),'') as od_flag 
    ,t1.od_ovtranam as od_ovtranam 
    ,replace(replace(t1.nextdayflag,chr(13),''),chr(10),'') as nextdayflag 
    ,replace(replace(t1.autoflag,chr(13),''),chr(10),'') as autoflag 
    ,replace(replace(t1.autocount,chr(13),''),chr(10),'') as autocount 
    ,replace(replace(t1.automsg,chr(13),''),chr(10),'') as automsg 
    ,replace(replace(t1.bindacct,chr(13),''),chr(10),'') as bindacct 
    ,replace(replace(t1.bindacctnm,chr(13),''),chr(10),'') as bindacctnm 
    ,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype 
    ,replace(replace(t1.bindacctopnbrn,chr(13),''),chr(10),'') as bindacctopnbrn 
    ,replace(replace(t1.lsttranst,chr(13),''),chr(10),'') as lsttranst 
    ,replace(replace(t1.tacctp,chr(13),''),chr(10),'') as tacctp 
    ,replace(replace(t1.limitorderid,chr(13),''),chr(10),'') as limitorderid 
    ,replace(replace(t1.isbindcard,chr(13),''),chr(10),'') as isbindcard 
    ,replace(replace(t1.globalseqno,chr(13),''),chr(10),'') as globalseqno 
    ,replace(replace(t1.returncode,chr(13),''),chr(10),'') as returncode 
    ,replace(replace(t1.returnmsg,chr(13),''),chr(10),'') as returnmsg 
    ,replace(replace(t1.transseqno,chr(13),''),chr(10),'') as transseqno 
    ,replace(replace(t1.sendouttm,chr(13),''),chr(10),'') as sendouttm 
    ,replace(replace(t1.finaccountid,chr(13),''),chr(10),'') as finaccountid 
    ,replace(replace(t1.acct_typ_id,chr(13),''),chr(10),'') as acct_typ_id 
    ,replace(replace(t1.memocntt,chr(13),''),chr(10),'') as memocntt 
    ,replace(replace(t1.acctchngflg,chr(13),''),chr(10),'') as acctchngflg 
    ,replace(replace(t1.tagrmt,chr(13),''),chr(10),'') as tagrmt 
    ,replace(replace(t1.cdtrfiacctfg,chr(13),''),chr(10),'') as cdtrfiacctfg 
    ,replace(replace(t1.inersettleacct,chr(13),''),chr(10),'') as inersettleacct 
    ,replace(replace(t1.inersettlename,chr(13),''),chr(10),'') as inersettlename 
    ,replace(replace(t1.unisoccdtcd,chr(13),''),chr(10),'') as unisoccdtcd 
    ,replace(replace(t1.regid,chr(13),''),chr(10),'') as regid 
    ,replace(replace(t1.splchrgsreqtpcd,chr(13),''),chr(10),'') as splchrgsreqtpcd 
    ,replace(replace(t1.trnsmtdt,chr(13),''),chr(10),'') as trnsmtdt 
    ,replace(replace(t1.payupbrn,chr(13),''),chr(10),'') as payupbrn 
    ,replace(replace(t1.incoupbrn,chr(13),''),chr(10),'') as incoupbrn 
    ,replace(replace(t1.agtflg,chr(13),''),chr(10),'') as agtflg 
    ,replace(replace(t1.agtidtp,chr(13),''),chr(10),'') as agtidtp 
    ,replace(replace(t1.agtidno,chr(13),''),chr(10),'') as agtidno 
    ,replace(replace(t1.agtname,chr(13),''),chr(10),'') as agtname 
    ,replace(replace(t1.agtphone,chr(13),''),chr(10),'') as agtphone 
    ,replace(replace(t1.budgetary,chr(13),''),chr(10),'') as budgetary 
    ,replace(replace(t1.exchgflg,chr(13),''),chr(10),'') as exchgflg 
    ,replace(replace(t1.orisrcsysssn,chr(13),''),chr(10),'') as orisrcsysssn 
    ,replace(replace(t1.orisyscd,chr(13),''),chr(10),'') as orisyscd 
    ,replace(replace(t1.redoflag,chr(13),''),chr(10),'') as redoflag 
    ,t1.etl_dt as etl_dt 
    ,t1.etl_timestamp as etl_timestamp 
  from ${iol_schema}.mpcs_a08tbetrx t1    --交易单表
 where t1.etl_dt = to_date('${batch_date}','yyyymmdd') ;
 commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'mpcs_a08tbetrx',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);