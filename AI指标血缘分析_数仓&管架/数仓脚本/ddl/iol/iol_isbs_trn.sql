/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_trn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_trn
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_trn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_trn(
    inr varchar2(12) -- 内部唯一id
    ,inidattim timestamp -- 开立日期
    ,inifrm varchar2(9) -- 交易名
    ,iniusr varchar2(12) -- 用户id
    ,ininam varchar2(60) -- 交易名
    ,ownref varchar2(24) -- 参考号
    ,objtyp varchar2(9) -- 业务表名称
    ,objinr varchar2(12) -- 业务表inr
    ,objnam varchar2(60) -- 交易对象描述
    ,ssninr varchar2(12) -- 连接 id
    ,smhnxt number(3,0) -- 报文、面函个数
    ,usg varchar2(9) -- 操作员组
    ,usr varchar2(12) -- 操作员
    ,cpldattim timestamp -- 完成日期
    ,infdsp varchar2(2) -- 显示信息
    ,inftxt varchar2(396) -- 信息文本
    ,relflg varchar2(2) -- 授权状态
    ,comflg varchar2(2) -- 提交标志
    ,comdat date -- 提交日期
    ,cortrninr varchar2(12) -- 被删除或需要修改的trn的inr
    ,xreflg varchar2(2) -- 重算标志
    ,xrecurblk varchar2(60) -- 可用货币
    ,relcur varchar2(5) -- 授权币种
    ,relamt number(18,3) -- 授权金额
    ,reloricur varchar2(5) -- 币种
    ,reloriamt number(18,3) -- 金额
    ,relreq varchar2(5) -- 授权请求状态
    ,relres varchar2(5) -- 签名状态
    ,cnfflg varchar2(2) -- 国外确认标志
    ,evttxt varchar2(4000) -- event事件描述
    ,rprusr varchar2(12) -- 退回到指定人员
    ,ordinr varchar2(12) -- ord表inr
    ,exedat date -- 执行日期
    ,etyextkey varchar2(12) -- 实体
    ,bchkeyinr varchar2(12) -- 经办机构
    ,accbchinr varchar2(12) -- 记账机构
    ,relreq0 varchar2(5) -- 单证中心授权请求
    ,relreq1 varchar2(5) -- 分行授权请求
    ,relreq2 varchar2(5) -- 支行授权请求
    ,relres0 varchar2(5) -- 单证中心签名
    ,relres1 varchar2(5) -- 分行签名
    ,relres2 varchar2(5) -- 支行签名
    ,relusr1 varchar2(150) -- 授权用户
    ,relusr2 varchar2(12) -- 授权用户
    ,relusr3 varchar2(12) -- 授权用户
    ,imginr varchar2(12) -- 图像inr
    ,branchinr varchar2(12) -- 业务所属支行inr
    ,orgflg varchar2(2) -- 机构标识
    ,addtxt varchar2(396) -- 附加信息
    ,gylsh varchar2(18) -- 核心柜员流水号
    ,gylsh1 varchar2(18) -- 核心表外柜员流水号
    ,yewgzh varchar2(30) -- 业务跟踪号
    ,cmtflg varchar2(2) -- cmt100报文标识
    ,ctrbnknum varchar2(36) -- 对手行行号
    ,ctrbnknam varchar2(60) -- 对手行行名
    ,atrdon varchar2(5) -- 
    ,atrque varchar2(5) -- 
    ,qjls varchar2(50) -- 全局流水号
    ,qjlscz varchar2(50) -- 全局流水号（冲正）
    ,czreason varchar2(300) -- 
    ,ywls varchar2(50) -- 
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
grant select on ${iol_schema}.isbs_trn to ${iml_schema};
grant select on ${iol_schema}.isbs_trn to ${icl_schema};
grant select on ${iol_schema}.isbs_trn to ${idl_schema};
grant select on ${iol_schema}.isbs_trn to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_trn is '交易流水';
comment on column ${iol_schema}.isbs_trn.inr is '内部唯一id';
comment on column ${iol_schema}.isbs_trn.inidattim is '开立日期';
comment on column ${iol_schema}.isbs_trn.inifrm is '交易名';
comment on column ${iol_schema}.isbs_trn.iniusr is '用户id';
comment on column ${iol_schema}.isbs_trn.ininam is '交易名';
comment on column ${iol_schema}.isbs_trn.ownref is '参考号';
comment on column ${iol_schema}.isbs_trn.objtyp is '业务表名称';
comment on column ${iol_schema}.isbs_trn.objinr is '业务表inr';
comment on column ${iol_schema}.isbs_trn.objnam is '交易对象描述';
comment on column ${iol_schema}.isbs_trn.ssninr is '连接 id';
comment on column ${iol_schema}.isbs_trn.smhnxt is '报文、面函个数';
comment on column ${iol_schema}.isbs_trn.usg is '操作员组';
comment on column ${iol_schema}.isbs_trn.usr is '操作员';
comment on column ${iol_schema}.isbs_trn.cpldattim is '完成日期';
comment on column ${iol_schema}.isbs_trn.infdsp is '显示信息';
comment on column ${iol_schema}.isbs_trn.inftxt is '信息文本';
comment on column ${iol_schema}.isbs_trn.relflg is '授权状态';
comment on column ${iol_schema}.isbs_trn.comflg is '提交标志';
comment on column ${iol_schema}.isbs_trn.comdat is '提交日期';
comment on column ${iol_schema}.isbs_trn.cortrninr is '被删除或需要修改的trn的inr';
comment on column ${iol_schema}.isbs_trn.xreflg is '重算标志';
comment on column ${iol_schema}.isbs_trn.xrecurblk is '可用货币';
comment on column ${iol_schema}.isbs_trn.relcur is '授权币种';
comment on column ${iol_schema}.isbs_trn.relamt is '授权金额';
comment on column ${iol_schema}.isbs_trn.reloricur is '币种';
comment on column ${iol_schema}.isbs_trn.reloriamt is '金额';
comment on column ${iol_schema}.isbs_trn.relreq is '授权请求状态';
comment on column ${iol_schema}.isbs_trn.relres is '签名状态';
comment on column ${iol_schema}.isbs_trn.cnfflg is '国外确认标志';
comment on column ${iol_schema}.isbs_trn.evttxt is 'event事件描述';
comment on column ${iol_schema}.isbs_trn.rprusr is '退回到指定人员';
comment on column ${iol_schema}.isbs_trn.ordinr is 'ord表inr';
comment on column ${iol_schema}.isbs_trn.exedat is '执行日期';
comment on column ${iol_schema}.isbs_trn.etyextkey is '实体';
comment on column ${iol_schema}.isbs_trn.bchkeyinr is '经办机构';
comment on column ${iol_schema}.isbs_trn.accbchinr is '记账机构';
comment on column ${iol_schema}.isbs_trn.relreq0 is '单证中心授权请求';
comment on column ${iol_schema}.isbs_trn.relreq1 is '分行授权请求';
comment on column ${iol_schema}.isbs_trn.relreq2 is '支行授权请求';
comment on column ${iol_schema}.isbs_trn.relres0 is '单证中心签名';
comment on column ${iol_schema}.isbs_trn.relres1 is '分行签名';
comment on column ${iol_schema}.isbs_trn.relres2 is '支行签名';
comment on column ${iol_schema}.isbs_trn.relusr1 is '授权用户';
comment on column ${iol_schema}.isbs_trn.relusr2 is '授权用户';
comment on column ${iol_schema}.isbs_trn.relusr3 is '授权用户';
comment on column ${iol_schema}.isbs_trn.imginr is '图像inr';
comment on column ${iol_schema}.isbs_trn.branchinr is '业务所属支行inr';
comment on column ${iol_schema}.isbs_trn.orgflg is '机构标识';
comment on column ${iol_schema}.isbs_trn.addtxt is '附加信息';
comment on column ${iol_schema}.isbs_trn.gylsh is '核心柜员流水号';
comment on column ${iol_schema}.isbs_trn.gylsh1 is '核心表外柜员流水号';
comment on column ${iol_schema}.isbs_trn.yewgzh is '业务跟踪号';
comment on column ${iol_schema}.isbs_trn.cmtflg is 'cmt100报文标识';
comment on column ${iol_schema}.isbs_trn.ctrbnknum is '对手行行号';
comment on column ${iol_schema}.isbs_trn.ctrbnknam is '对手行行名';
comment on column ${iol_schema}.isbs_trn.atrdon is '';
comment on column ${iol_schema}.isbs_trn.atrque is '';
comment on column ${iol_schema}.isbs_trn.qjls is '全局流水号';
comment on column ${iol_schema}.isbs_trn.qjlscz is '全局流水号（冲正）';
comment on column ${iol_schema}.isbs_trn.czreason is '';
comment on column ${iol_schema}.isbs_trn.ywls is '';
comment on column ${iol_schema}.isbs_trn.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_trn.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_trn.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_trn.etl_timestamp is 'ETL处理时间戳';
