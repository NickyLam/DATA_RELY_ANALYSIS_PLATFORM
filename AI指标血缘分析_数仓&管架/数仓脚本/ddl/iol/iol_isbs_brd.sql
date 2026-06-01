/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_brd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_brd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_brd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_brd(
    inr varchar2(12) -- 进口单据inr号
    ,ownref varchar2(24) -- 来单参考号
    ,nam varchar2(60) -- 来单名称
    ,ownusr varchar2(12) -- 负责人
    ,credat date -- 寄单日期
    ,opndat date -- 开证日期
    ,clsdat date -- 结束日期
    ,pnttyp varchar2(9) -- 父类类型
    ,pntinr varchar2(12) -- 父类交易inr号
    ,predat date -- 寄单行寄单日期
    ,shpdat date -- 最迟装运日期
    ,spddat date -- 过期日期
    ,totdat date -- 总天数
    ,advdat date -- 通知日期
    ,matdat date -- 效期
    ,rcvdat date -- 提单收到日期
    ,disdat date -- 不符点通知日期
    ,docflg varchar2(2) -- 到单标志
    ,rejflg varchar2(2) -- 拒付标志
    ,approvcod varchar2(2) -- 是否批准
    ,relgodflg varchar2(2) -- 货物授权标志
    ,relgoddat date -- 授权日期
    ,trpdocnum varchar2(60) -- 传送单据数目
    ,frepayflg varchar2(2) -- 免付款交单标志
    ,ver varchar2(6) -- 版本号
    ,advtyp varchar2(5) -- 接收的的通知类型
    ,reltyp varchar2(3) -- 授权类型
    ,expdat date -- 提货担保开立日期
    ,rtoaplflg varchar2(2) -- 货物授权申请人标志
    ,trpdoctyp varchar2(38) -- 提单类型
    ,tradat date -- 提单日期
    ,tramod varchar2(30) -- 运输类型
    ,mattxtflg varchar2(2) -- 多期限标志
    ,dscinsflg varchar2(2) -- 单据差异标志
    ,docprbrol varchar2(5) -- 提交角色
    ,docsta varchar2(2) -- 单据类型
    ,igndisflg varchar2(2) -- 忽略不符点标志
    ,totcur varchar2(5) -- 付款总金额币种
    ,totamt number(18,3) -- 付款总金额
    ,payrol varchar2(5) -- 付款人
    ,acpnowflg varchar2(2) -- 承兑标志
    ,orddat date -- 来单日期
    ,advdocflg varchar2(2) -- 退单标志
    ,etyextkey varchar2(12) -- 实体组
    ,bchkeyinr varchar2(12) -- 经办机构号
    ,branchinr varchar2(12) -- 所属机构号
    ,ngrcod varchar2(9) -- 货物代码
    ,sgdinr varchar2(12) -- 提货担保inr
    ,blnum varchar2(30) -- 提单号
    ,shgref varchar2(24) -- 提货担保参考号
    ,fincod varchar2(30) -- 借据号
    ,fintyp varchar2(11) -- 业务品种
    ,nraflg varchar2(2) -- nra付款标志
    ,qsqdbh varchar2(5) -- 清算渠道
    ,invnum varchar2(45) -- 
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
grant select on ${iol_schema}.isbs_brd to ${iml_schema};
grant select on ${iol_schema}.isbs_brd to ${icl_schema};
grant select on ${iol_schema}.isbs_brd to ${idl_schema};
grant select on ${iol_schema}.isbs_brd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_brd is '进口信用证下单据业务信息(存放短字节内容)';
comment on column ${iol_schema}.isbs_brd.inr is '进口单据inr号';
comment on column ${iol_schema}.isbs_brd.ownref is '来单参考号';
comment on column ${iol_schema}.isbs_brd.nam is '来单名称';
comment on column ${iol_schema}.isbs_brd.ownusr is '负责人';
comment on column ${iol_schema}.isbs_brd.credat is '寄单日期';
comment on column ${iol_schema}.isbs_brd.opndat is '开证日期';
comment on column ${iol_schema}.isbs_brd.clsdat is '结束日期';
comment on column ${iol_schema}.isbs_brd.pnttyp is '父类类型';
comment on column ${iol_schema}.isbs_brd.pntinr is '父类交易inr号';
comment on column ${iol_schema}.isbs_brd.predat is '寄单行寄单日期';
comment on column ${iol_schema}.isbs_brd.shpdat is '最迟装运日期';
comment on column ${iol_schema}.isbs_brd.spddat is '过期日期';
comment on column ${iol_schema}.isbs_brd.totdat is '总天数';
comment on column ${iol_schema}.isbs_brd.advdat is '通知日期';
comment on column ${iol_schema}.isbs_brd.matdat is '效期';
comment on column ${iol_schema}.isbs_brd.rcvdat is '提单收到日期';
comment on column ${iol_schema}.isbs_brd.disdat is '不符点通知日期';
comment on column ${iol_schema}.isbs_brd.docflg is '到单标志';
comment on column ${iol_schema}.isbs_brd.rejflg is '拒付标志';
comment on column ${iol_schema}.isbs_brd.approvcod is '是否批准';
comment on column ${iol_schema}.isbs_brd.relgodflg is '货物授权标志';
comment on column ${iol_schema}.isbs_brd.relgoddat is '授权日期';
comment on column ${iol_schema}.isbs_brd.trpdocnum is '传送单据数目';
comment on column ${iol_schema}.isbs_brd.frepayflg is '免付款交单标志';
comment on column ${iol_schema}.isbs_brd.ver is '版本号';
comment on column ${iol_schema}.isbs_brd.advtyp is '接收的的通知类型';
comment on column ${iol_schema}.isbs_brd.reltyp is '授权类型';
comment on column ${iol_schema}.isbs_brd.expdat is '提货担保开立日期';
comment on column ${iol_schema}.isbs_brd.rtoaplflg is '货物授权申请人标志';
comment on column ${iol_schema}.isbs_brd.trpdoctyp is '提单类型';
comment on column ${iol_schema}.isbs_brd.tradat is '提单日期';
comment on column ${iol_schema}.isbs_brd.tramod is '运输类型';
comment on column ${iol_schema}.isbs_brd.mattxtflg is '多期限标志';
comment on column ${iol_schema}.isbs_brd.dscinsflg is '单据差异标志';
comment on column ${iol_schema}.isbs_brd.docprbrol is '提交角色';
comment on column ${iol_schema}.isbs_brd.docsta is '单据类型';
comment on column ${iol_schema}.isbs_brd.igndisflg is '忽略不符点标志';
comment on column ${iol_schema}.isbs_brd.totcur is '付款总金额币种';
comment on column ${iol_schema}.isbs_brd.totamt is '付款总金额';
comment on column ${iol_schema}.isbs_brd.payrol is '付款人';
comment on column ${iol_schema}.isbs_brd.acpnowflg is '承兑标志';
comment on column ${iol_schema}.isbs_brd.orddat is '来单日期';
comment on column ${iol_schema}.isbs_brd.advdocflg is '退单标志';
comment on column ${iol_schema}.isbs_brd.etyextkey is '实体组';
comment on column ${iol_schema}.isbs_brd.bchkeyinr is '经办机构号';
comment on column ${iol_schema}.isbs_brd.branchinr is '所属机构号';
comment on column ${iol_schema}.isbs_brd.ngrcod is '货物代码';
comment on column ${iol_schema}.isbs_brd.sgdinr is '提货担保inr';
comment on column ${iol_schema}.isbs_brd.blnum is '提单号';
comment on column ${iol_schema}.isbs_brd.shgref is '提货担保参考号';
comment on column ${iol_schema}.isbs_brd.fincod is '借据号';
comment on column ${iol_schema}.isbs_brd.fintyp is '业务品种';
comment on column ${iol_schema}.isbs_brd.nraflg is 'nra付款标志';
comment on column ${iol_schema}.isbs_brd.qsqdbh is '清算渠道';
comment on column ${iol_schema}.isbs_brd.invnum is '';
comment on column ${iol_schema}.isbs_brd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_brd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_brd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_brd.etl_timestamp is 'ETL处理时间戳';
