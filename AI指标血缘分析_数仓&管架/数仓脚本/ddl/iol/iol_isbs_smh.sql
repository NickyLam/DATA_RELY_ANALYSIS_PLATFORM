/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_smh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_smh
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_smh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_smh(
    inr varchar2(12) -- 内部唯一流水号，主键
    ,objtyp varchar2(9) -- 关联对象类型
    ,objinr varchar2(12) -- 关联对象inr
    ,trntyp varchar2(9) -- 交易类型
    ,trninr varchar2(12) -- 交易inr
    ,trnsub number(3,0) -- 交易级别
    ,extkey varchar2(48) -- 外部关键字
    ,nam varchar2(60) -- 基本信息描述
    ,creusr varchar2(12) -- 创建人
    ,crefrm varchar2(12) -- 所在交易
    ,credattim timestamp -- 创建时间
    ,dir varchar2(2) -- 发出或接受标志
    ,docpth varchar2(60) -- 存储位置
    ,docfil varchar2(48) -- message的文件名称
    ,docfxt varchar2(5) -- 文件后缀
    ,docmac varchar2(12) -- mac
    ,msgpos number(10,0) -- 所在message的位置
    ,msglen number(10,0) -- 在message的长度
    ,grpinr varchar2(12) -- message组inr
    ,grpseq number(2,0) -- message组队列
    ,cortyp varchar2(5) -- 类型
    ,cortypsub varchar2(5) -- subtype of message (defines srv)
    ,apf varchar2(9) -- 打印格式
    ,sndkey varchar2(75) -- receiver key
    ,apfcnt varchar2(75) -- count per form
    ,ptainr varchar2(12) -- pta的inr
    ,oriflg varchar2(2) -- type of copy
    ,orismhinr varchar2(12) -- message的唯一id
    ,partflg varchar2(5) -- message的部分标志
    ,msgtyp varchar2(30) -- received或sent标志
    ,relcur varchar2(5) -- 相关币种
    ,relamt number(18,3) -- 相关金额
    ,sysno varchar2(23) -- 清算报文的清算编号
    ,staflg varchar2(2) -- flag (m 999加押，t  telex加押)
    ,times number(16,0) -- 次数
    ,sndref varchar2(53) -- 
    ,ownref varchar2(53) -- 
    ,bindflg varchar2(2) -- 
    ,cndinr varchar2(12) -- 
    ,ackflg varchar2(5) -- 
    ,mtdesc varchar2(300) -- 
    ,asiflg varchar2(5) -- 
    ,matflg varchar2(5) -- 
    ,clrflg varchar2(5) -- 
    ,msgpri varchar2(3) -- 
    ,tag121 varchar2(54) -- 
    ,tag111 varchar2(5) -- 
    ,sndflg varchar2(2) -- 
    ,f79sta varchar2(15) -- 
    ,f71f varchar2(150) -- 
    ,f71a varchar2(5) -- 
    ,f79 varchar2(150) -- 
    ,f33b varchar2(60) -- 
    ,valdat varchar2(30) -- 
    ,cpsflg varchar2(2) -- 
    ,gpiflg varchar2(2) -- gpi标志
    ,tag52a varchar2(36) -- 报文的tag52a
    ,tag56a varchar2(36) -- 报文的tag56a
    ,tag57a varchar2(36) -- 报文的tag57a
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
grant select on ${iol_schema}.isbs_smh to ${iml_schema};
grant select on ${iol_schema}.isbs_smh to ${icl_schema};
grant select on ${iol_schema}.isbs_smh to ${idl_schema};
grant select on ${iol_schema}.isbs_smh to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_smh is '面函和报文信息';
comment on column ${iol_schema}.isbs_smh.inr is '内部唯一流水号，主键';
comment on column ${iol_schema}.isbs_smh.objtyp is '关联对象类型';
comment on column ${iol_schema}.isbs_smh.objinr is '关联对象inr';
comment on column ${iol_schema}.isbs_smh.trntyp is '交易类型';
comment on column ${iol_schema}.isbs_smh.trninr is '交易inr';
comment on column ${iol_schema}.isbs_smh.trnsub is '交易级别';
comment on column ${iol_schema}.isbs_smh.extkey is '外部关键字';
comment on column ${iol_schema}.isbs_smh.nam is '基本信息描述';
comment on column ${iol_schema}.isbs_smh.creusr is '创建人';
comment on column ${iol_schema}.isbs_smh.crefrm is '所在交易';
comment on column ${iol_schema}.isbs_smh.credattim is '创建时间';
comment on column ${iol_schema}.isbs_smh.dir is '发出或接受标志';
comment on column ${iol_schema}.isbs_smh.docpth is '存储位置';
comment on column ${iol_schema}.isbs_smh.docfil is 'message的文件名称';
comment on column ${iol_schema}.isbs_smh.docfxt is '文件后缀';
comment on column ${iol_schema}.isbs_smh.docmac is 'mac';
comment on column ${iol_schema}.isbs_smh.msgpos is '所在message的位置';
comment on column ${iol_schema}.isbs_smh.msglen is '在message的长度';
comment on column ${iol_schema}.isbs_smh.grpinr is 'message组inr';
comment on column ${iol_schema}.isbs_smh.grpseq is 'message组队列';
comment on column ${iol_schema}.isbs_smh.cortyp is '类型';
comment on column ${iol_schema}.isbs_smh.cortypsub is 'subtype of message (defines srv)';
comment on column ${iol_schema}.isbs_smh.apf is '打印格式';
comment on column ${iol_schema}.isbs_smh.sndkey is 'receiver key';
comment on column ${iol_schema}.isbs_smh.apfcnt is 'count per form';
comment on column ${iol_schema}.isbs_smh.ptainr is 'pta的inr';
comment on column ${iol_schema}.isbs_smh.oriflg is 'type of copy';
comment on column ${iol_schema}.isbs_smh.orismhinr is 'message的唯一id';
comment on column ${iol_schema}.isbs_smh.partflg is 'message的部分标志';
comment on column ${iol_schema}.isbs_smh.msgtyp is 'received或sent标志';
comment on column ${iol_schema}.isbs_smh.relcur is '相关币种';
comment on column ${iol_schema}.isbs_smh.relamt is '相关金额';
comment on column ${iol_schema}.isbs_smh.sysno is '清算报文的清算编号';
comment on column ${iol_schema}.isbs_smh.staflg is 'flag (m 999加押，t  telex加押)';
comment on column ${iol_schema}.isbs_smh.times is '次数';
comment on column ${iol_schema}.isbs_smh.sndref is '';
comment on column ${iol_schema}.isbs_smh.ownref is '';
comment on column ${iol_schema}.isbs_smh.bindflg is '';
comment on column ${iol_schema}.isbs_smh.cndinr is '';
comment on column ${iol_schema}.isbs_smh.ackflg is '';
comment on column ${iol_schema}.isbs_smh.mtdesc is '';
comment on column ${iol_schema}.isbs_smh.asiflg is '';
comment on column ${iol_schema}.isbs_smh.matflg is '';
comment on column ${iol_schema}.isbs_smh.clrflg is '';
comment on column ${iol_schema}.isbs_smh.msgpri is '';
comment on column ${iol_schema}.isbs_smh.tag121 is '';
comment on column ${iol_schema}.isbs_smh.tag111 is '';
comment on column ${iol_schema}.isbs_smh.sndflg is '';
comment on column ${iol_schema}.isbs_smh.f79sta is '';
comment on column ${iol_schema}.isbs_smh.f71f is '';
comment on column ${iol_schema}.isbs_smh.f71a is '';
comment on column ${iol_schema}.isbs_smh.f79 is '';
comment on column ${iol_schema}.isbs_smh.f33b is '';
comment on column ${iol_schema}.isbs_smh.valdat is '';
comment on column ${iol_schema}.isbs_smh.cpsflg is '';
comment on column ${iol_schema}.isbs_smh.gpiflg is 'gpi标志';
comment on column ${iol_schema}.isbs_smh.tag52a is '报文的tag52a';
comment on column ${iol_schema}.isbs_smh.tag56a is '报文的tag56a';
comment on column ${iol_schema}.isbs_smh.tag57a is '报文的tag57a';
comment on column ${iol_schema}.isbs_smh.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_smh.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_smh.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_smh.etl_timestamp is 'ETL处理时间戳';
