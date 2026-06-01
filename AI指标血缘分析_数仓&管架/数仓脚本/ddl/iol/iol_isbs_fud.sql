/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_fud
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_fud
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_fud purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fud(
    inr varchar2(12) -- 主键
    ,ownref varchar2(24) -- own reference (业务参考号)
    ,nam varchar2(60) -- 显示名称
    ,opndat date -- 创建日期
    ,proref varchar2(48) -- 委托书编号
    ,ovaref varchar2(48) -- 客户参数编号
    ,trnway varchar2(2) -- 交易方向
    ,lmttyp varchar2(2) -- 交割类型
    ,expdat date -- 到期日
    ,frgact varchar2(33) -- 外币账号
    ,frgcur varchar2(5) -- 外币币别
    ,frgamt number(18,2) -- 外币金额
    ,rat number(14,6) -- 成交汇率
    ,cnyact varchar2(33) -- 人民币账号
    ,cnycur varchar2(5) -- 人民币币别
    ,cnyamt number(18,2) -- 人民币金额
    ,clsdat date -- 闭卷日期
    ,mrgact varchar2(27) -- 保证金账号
    ,mrgcur varchar2(5) -- 保证金币别
    ,cshpct number(7,4) -- 保证金比例
    ,cshpctori number(7,4) -- 当前保证金比例
    ,aplptyinr varchar2(12) -- 申请人pty表inr
    ,aplptainr varchar2(12) -- 申请人pta表inr
    ,aplnam varchar2(60) -- 客户名称
    ,apltyp varchar2(2) -- 客户类型
    ,aplref varchar2(24) -- 客户参考号
    ,inqref varchar2(24) -- 询价编号
    ,fixlmt varchar2(2) -- 固定期限交割)
    ,begdat date -- 起始日
    ,enddat date -- 终止日
    ,stdlmt varchar2(9) -- 标准期限
    ,extlmt varchar2(2) -- 是否可宽限
    ,extflg varchar2(2) -- 择期交割通知标志
    ,hdltyp varchar2(2) -- 合理状态
    ,sysrat number(14,6) -- 系统内平盘汇率
    ,sptrat number(14,6) -- 远期价格
    ,appdat date -- 客户申请日期
    ,infdsp varchar2(2) -- display infotext
    ,spread varchar2(2) -- 展期标志
    ,ver varchar2(6) -- 版本号
    ,credat date -- 登记日期
    ,pnttyp varchar2(9) -- 父业务类型
    ,pntinr varchar2(12) -- 父业务主键
    ,branchinr varchar2(12) -- 所属机构主键
    ,bchkeyinr varchar2(12) -- 经办机构主键
    ,lstamt number(18,2) -- 损益人民币金额
    ,syflg varchar2(2) -- 是否损失
    ,losamt number(18,3) -- 我行损失金额
    ,loscur varchar2(5) -- 币种
    ,lstcur varchar2(5) -- 币种
    ,etyextkey varchar2(12) -- 业务主体信息
    ,trnman varchar2(3) -- 交易主体
    ,trdint varchar2(5) -- trade in
    ,trdout varchar2(5) -- trade out
    ,regref varchar2(24) -- register reference
    ,setdat date -- settlement date
    ,setref varchar2(24) -- 交割编号
    ,cetrat number(14,6) -- 客户展期近端汇率
    ,ceurat number(14,6) -- 客户展期远端汇率
    ,cesamt number(18,2) -- 客户展期损益
    ,cesact varchar2(27) -- 客户展期损益入/出账号
    ,betrat number(14,6) -- 我行展期近端汇率
    ,beurat number(14,6) -- 我行展期远端汇率
    ,besamt number(18,2) -- 我行展期损益
    ,eusinc number(18,2) -- 展期价差收益
    ,eudtyp varchar2(2) -- 日期展期类型
    ,cdrrat number(14,6) -- 客户对冲价格
    ,cdramt number(18,2) -- 客户损失金额
    ,cdract varchar2(27) -- 客户扣款"号(违约)
    ,bdrrat number(14,6) -- 我行对冲价格
    ,bdramt number(18,2) -- 我行违约损益
    ,dcrinc number(18,2) -- 违约价差收益
    ,mrgcurbnk varchar2(5) -- margin currency (保证金币别)
    ,cshpctbnk number(3,0) -- margin percent (保证金比例)
    ,cnyamtbnk number(18,2) -- cn amount (人民币金额-银行端)
    ,cnycurbnk varchar2(5) -- cn currency (人民币币别-银行端)
    ,cvaref varchar2(48) -- 客户协议编号
    ,inffrgamt number(18,3) -- 通知交割金额
    ,infexpdat date -- 通知交割到期日
    ,inffvaref varchar2(48) -- 签约编号
    ,infadvflg varchar2(2) -- 通知交割类型
    ,clsflg varchar2(2) -- 授信闭卷状态
    ,cdtref varchar2(30) -- 授信编号
    ,lmtpct number(3,0) -- 授信额度比例
    ,ccvint varchar2(5) -- 保证金计息方式
    ,ccvrat number(14,6) -- 保证金中间价
    ,lmdamt number(16,3) -- 授信额度扣减金额
    ,mrgamt number(16,3) -- 本次保证金金额
    ,lmtamt number(16,3) -- 展期新增授信额度
    ,mrgamtbnk number(16,3) -- 银行端保证金/授信额度
    ,ownusr varchar2(12) -- responsible user
    ,oldownref varchar2(33) -- 历史参考号
    ,mrgamtprt number(16,3) -- 保证金余额
    ,padflg varchar2(2) -- 垫款标志
    ,selflg varchar2(2) -- 自营标志
    ,zjly varchar2(60) -- 资金来源
    ,rptcod varchar2(33) -- 申报代码
    ,dbway varchar2(2) -- 担保方式
    ,setlmttyp varchar2(2) -- 交割期限类型
    ,rcvbnkamt number(16,2) -- 收合作银行金额
    ,rcvtyp varchar2(2) -- 收款类
    ,ownact varchar2(51) -- 我行扣款/收款账号
    ,seqno varchar2(8) -- 账户序列号
    ,hkchn varchar2(8) -- 汇款渠道
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
grant select on ${iol_schema}.isbs_fud to ${iml_schema};
grant select on ${iol_schema}.isbs_fud to ${icl_schema};
grant select on ${iol_schema}.isbs_fud to ${idl_schema};
grant select on ${iol_schema}.isbs_fud to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_fud is '远期结售汇信息表';
comment on column ${iol_schema}.isbs_fud.inr is '主键';
comment on column ${iol_schema}.isbs_fud.ownref is 'own reference (业务参考号)';
comment on column ${iol_schema}.isbs_fud.nam is '显示名称';
comment on column ${iol_schema}.isbs_fud.opndat is '创建日期';
comment on column ${iol_schema}.isbs_fud.proref is '委托书编号';
comment on column ${iol_schema}.isbs_fud.ovaref is '客户参数编号';
comment on column ${iol_schema}.isbs_fud.trnway is '交易方向';
comment on column ${iol_schema}.isbs_fud.lmttyp is '交割类型';
comment on column ${iol_schema}.isbs_fud.expdat is '到期日';
comment on column ${iol_schema}.isbs_fud.frgact is '外币账号';
comment on column ${iol_schema}.isbs_fud.frgcur is '外币币别';
comment on column ${iol_schema}.isbs_fud.frgamt is '外币金额';
comment on column ${iol_schema}.isbs_fud.rat is '成交汇率';
comment on column ${iol_schema}.isbs_fud.cnyact is '人民币账号';
comment on column ${iol_schema}.isbs_fud.cnycur is '人民币币别';
comment on column ${iol_schema}.isbs_fud.cnyamt is '人民币金额';
comment on column ${iol_schema}.isbs_fud.clsdat is '闭卷日期';
comment on column ${iol_schema}.isbs_fud.mrgact is '保证金账号';
comment on column ${iol_schema}.isbs_fud.mrgcur is '保证金币别';
comment on column ${iol_schema}.isbs_fud.cshpct is '保证金比例';
comment on column ${iol_schema}.isbs_fud.cshpctori is '当前保证金比例';
comment on column ${iol_schema}.isbs_fud.aplptyinr is '申请人pty表inr';
comment on column ${iol_schema}.isbs_fud.aplptainr is '申请人pta表inr';
comment on column ${iol_schema}.isbs_fud.aplnam is '客户名称';
comment on column ${iol_schema}.isbs_fud.apltyp is '客户类型';
comment on column ${iol_schema}.isbs_fud.aplref is '客户参考号';
comment on column ${iol_schema}.isbs_fud.inqref is '询价编号';
comment on column ${iol_schema}.isbs_fud.fixlmt is '固定期限交割)';
comment on column ${iol_schema}.isbs_fud.begdat is '起始日';
comment on column ${iol_schema}.isbs_fud.enddat is '终止日';
comment on column ${iol_schema}.isbs_fud.stdlmt is '标准期限';
comment on column ${iol_schema}.isbs_fud.extlmt is '是否可宽限';
comment on column ${iol_schema}.isbs_fud.extflg is '择期交割通知标志';
comment on column ${iol_schema}.isbs_fud.hdltyp is '合理状态';
comment on column ${iol_schema}.isbs_fud.sysrat is '系统内平盘汇率';
comment on column ${iol_schema}.isbs_fud.sptrat is '远期价格';
comment on column ${iol_schema}.isbs_fud.appdat is '客户申请日期';
comment on column ${iol_schema}.isbs_fud.infdsp is 'display infotext';
comment on column ${iol_schema}.isbs_fud.spread is '展期标志';
comment on column ${iol_schema}.isbs_fud.ver is '版本号';
comment on column ${iol_schema}.isbs_fud.credat is '登记日期';
comment on column ${iol_schema}.isbs_fud.pnttyp is '父业务类型';
comment on column ${iol_schema}.isbs_fud.pntinr is '父业务主键';
comment on column ${iol_schema}.isbs_fud.branchinr is '所属机构主键';
comment on column ${iol_schema}.isbs_fud.bchkeyinr is '经办机构主键';
comment on column ${iol_schema}.isbs_fud.lstamt is '损益人民币金额';
comment on column ${iol_schema}.isbs_fud.syflg is '是否损失';
comment on column ${iol_schema}.isbs_fud.losamt is '我行损失金额';
comment on column ${iol_schema}.isbs_fud.loscur is '币种';
comment on column ${iol_schema}.isbs_fud.lstcur is '币种';
comment on column ${iol_schema}.isbs_fud.etyextkey is '业务主体信息';
comment on column ${iol_schema}.isbs_fud.trnman is '交易主体';
comment on column ${iol_schema}.isbs_fud.trdint is 'trade in';
comment on column ${iol_schema}.isbs_fud.trdout is 'trade out';
comment on column ${iol_schema}.isbs_fud.regref is 'register reference';
comment on column ${iol_schema}.isbs_fud.setdat is 'settlement date';
comment on column ${iol_schema}.isbs_fud.setref is '交割编号';
comment on column ${iol_schema}.isbs_fud.cetrat is '客户展期近端汇率';
comment on column ${iol_schema}.isbs_fud.ceurat is '客户展期远端汇率';
comment on column ${iol_schema}.isbs_fud.cesamt is '客户展期损益';
comment on column ${iol_schema}.isbs_fud.cesact is '客户展期损益入/出账号';
comment on column ${iol_schema}.isbs_fud.betrat is '我行展期近端汇率';
comment on column ${iol_schema}.isbs_fud.beurat is '我行展期远端汇率';
comment on column ${iol_schema}.isbs_fud.besamt is '我行展期损益';
comment on column ${iol_schema}.isbs_fud.eusinc is '展期价差收益';
comment on column ${iol_schema}.isbs_fud.eudtyp is '日期展期类型';
comment on column ${iol_schema}.isbs_fud.cdrrat is '客户对冲价格';
comment on column ${iol_schema}.isbs_fud.cdramt is '客户损失金额';
comment on column ${iol_schema}.isbs_fud.cdract is '客户扣款"号(违约)';
comment on column ${iol_schema}.isbs_fud.bdrrat is '我行对冲价格';
comment on column ${iol_schema}.isbs_fud.bdramt is '我行违约损益';
comment on column ${iol_schema}.isbs_fud.dcrinc is '违约价差收益';
comment on column ${iol_schema}.isbs_fud.mrgcurbnk is 'margin currency (保证金币别)';
comment on column ${iol_schema}.isbs_fud.cshpctbnk is 'margin percent (保证金比例)';
comment on column ${iol_schema}.isbs_fud.cnyamtbnk is 'cn amount (人民币金额-银行端)';
comment on column ${iol_schema}.isbs_fud.cnycurbnk is 'cn currency (人民币币别-银行端)';
comment on column ${iol_schema}.isbs_fud.cvaref is '客户协议编号';
comment on column ${iol_schema}.isbs_fud.inffrgamt is '通知交割金额';
comment on column ${iol_schema}.isbs_fud.infexpdat is '通知交割到期日';
comment on column ${iol_schema}.isbs_fud.inffvaref is '签约编号';
comment on column ${iol_schema}.isbs_fud.infadvflg is '通知交割类型';
comment on column ${iol_schema}.isbs_fud.clsflg is '授信闭卷状态';
comment on column ${iol_schema}.isbs_fud.cdtref is '授信编号';
comment on column ${iol_schema}.isbs_fud.lmtpct is '授信额度比例';
comment on column ${iol_schema}.isbs_fud.ccvint is '保证金计息方式';
comment on column ${iol_schema}.isbs_fud.ccvrat is '保证金中间价';
comment on column ${iol_schema}.isbs_fud.lmdamt is '授信额度扣减金额';
comment on column ${iol_schema}.isbs_fud.mrgamt is '本次保证金金额';
comment on column ${iol_schema}.isbs_fud.lmtamt is '展期新增授信额度';
comment on column ${iol_schema}.isbs_fud.mrgamtbnk is '银行端保证金/授信额度';
comment on column ${iol_schema}.isbs_fud.ownusr is 'responsible user';
comment on column ${iol_schema}.isbs_fud.oldownref is '历史参考号';
comment on column ${iol_schema}.isbs_fud.mrgamtprt is '保证金余额';
comment on column ${iol_schema}.isbs_fud.padflg is '垫款标志';
comment on column ${iol_schema}.isbs_fud.selflg is '自营标志';
comment on column ${iol_schema}.isbs_fud.zjly is '资金来源';
comment on column ${iol_schema}.isbs_fud.rptcod is '申报代码';
comment on column ${iol_schema}.isbs_fud.dbway is '担保方式';
comment on column ${iol_schema}.isbs_fud.setlmttyp is '交割期限类型';
comment on column ${iol_schema}.isbs_fud.rcvbnkamt is '收合作银行金额';
comment on column ${iol_schema}.isbs_fud.rcvtyp is '收款类';
comment on column ${iol_schema}.isbs_fud.ownact is '我行扣款/收款账号';
comment on column ${iol_schema}.isbs_fud.seqno is '账户序列号';
comment on column ${iol_schema}.isbs_fud.hkchn is '汇款渠道';
comment on column ${iol_schema}.isbs_fud.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_fud.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_fud.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_fud.etl_timestamp is 'ETL处理时间戳';
