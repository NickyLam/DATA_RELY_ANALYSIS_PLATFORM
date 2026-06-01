/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a77tfreezeqryusracct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a77tfreezeqryusracct
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a77tfreezeqryusracct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a77tfreezeqryusracct(
    docno varchar2(75) -- 协作编号
    ,case_index number(22) -- 
    ,caseno varchar2(150) -- 案件编号
    ,casename varchar2(150) -- 案件名称
    ,exeunit varchar2(150) -- 侦办单位名称
    ,unique_index number(22) -- 
    ,uniqueid varchar2(60) -- 唯一标识
    ,type varchar2(15) -- 类型
    ,name varchar2(150) -- 名称
    ,idtype varchar2(30) -- 证件类型
    ,id varchar2(27) -- 证件号码
    ,acct_index number(22) -- 
    ,bankcode varchar2(75) -- 开户行代码
    ,bankname varchar2(150) -- 开户行名称
    ,froseq varchar2(75) -- 冻结流水号
    ,oldfroseq varchar2(75) -- 原冻结流水号
    ,account varchar2(75) -- 账号
    ,currency varchar2(30) -- 币种
    ,exchangetype varchar2(30) -- 汇钞类型
    ,frotype varchar2(15) -- 冻结类型 1 普通冻结 2 轮候冻结 3 续冻
    ,fromode varchar2(15) -- 冻结方式 1 按金额冻结 2 按账号冻结
    ,frobanlance number(17,2) -- 冻结金额
    ,freezeappdate varchar2(45) -- 冻结申请时间
    ,frostartdate varchar2(30) -- 冻结开始日期
    ,froenddate varchar2(30) -- 冻结结束日期
    ,fronotifydoc varchar2(150) -- 冻结存款通知书
    ,froflag varchar2(5) -- 冻结标志 1已冻结 2未冻结
    ,frobanlance_1 number(17,2) -- 应冻结金额
    ,frobanlance_2 number(17,2) -- 已冻结金额
    ,frobanlance_3 number(17,2) -- 未冻结金额
    ,frobanlance_4 number(17,2) -- 冻结额度
    ,frostartdate_1 varchar2(30) -- 
    ,froenddate_1 varchar2(30) -- 
    ,memo varchar2(300) -- 原因
    ,servicetime varchar2(30) -- 送达时间
    ,servicedoc varchar2(150) -- 送达证
    ,replydoc varchar2(150) -- 回执
    ,filetype varchar2(15) -- 文件格式
    ,filetype2 varchar2(15) -- 回执文件格式
    ,tlrno varchar2(30) -- 
    ,tlrdt varchar2(12) -- 
    ,tlrtm varchar2(9) -- 
    ,tlrjnlno varchar2(48) -- 
    ,updt varchar2(12) -- 
    ,uptm varchar2(9) -- 
    ,isregister varchar2(2) -- 
    ,openbr varchar2(15) -- 账户开户行
    ,isdeal varchar2(2) -- 是否已处理 0-未处理 1-已处理
    ,ischeck varchar2(2) -- 是否复核
    ,isneed varchar2(2) -- 是否需要查询子户号 0-否 1-是
    ,notifydoc varchar2(60) -- 文书名称
    ,docnum varchar2(45) -- 文书文号
    ,istransee varchar2(2) -- 是否调取电子证据 1-是 2-否
    ,custnm varchar2(150) -- 户名
    ,xtbz varchar2(6) -- 
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
grant select on ${iol_schema}.mpcs_a77tfreezeqryusracct to ${iml_schema};
grant select on ${iol_schema}.mpcs_a77tfreezeqryusracct to ${icl_schema};
grant select on ${iol_schema}.mpcs_a77tfreezeqryusracct to ${idl_schema};
grant select on ${iol_schema}.mpcs_a77tfreezeqryusracct to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a77tfreezeqryusracct is '广东公安和检察院冻结流水';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.docno is '协作编号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.case_index is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.caseno is '案件编号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.casename is '案件名称';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.exeunit is '侦办单位名称';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.unique_index is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.uniqueid is '唯一标识';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.type is '类型';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.name is '名称';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.idtype is '证件类型';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.id is '证件号码';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.acct_index is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.bankcode is '开户行代码';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.bankname is '开户行名称';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.froseq is '冻结流水号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.oldfroseq is '原冻结流水号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.account is '账号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.currency is '币种';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.exchangetype is '汇钞类型';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.frotype is '冻结类型 1 普通冻结 2 轮候冻结 3 续冻';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.fromode is '冻结方式 1 按金额冻结 2 按账号冻结';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.frobanlance is '冻结金额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.freezeappdate is '冻结申请时间';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.frostartdate is '冻结开始日期';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.froenddate is '冻结结束日期';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.fronotifydoc is '冻结存款通知书';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.froflag is '冻结标志 1已冻结 2未冻结';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.frobanlance_1 is '应冻结金额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.frobanlance_2 is '已冻结金额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.frobanlance_3 is '未冻结金额';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.frobanlance_4 is '冻结额度';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.frostartdate_1 is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.froenddate_1 is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.memo is '原因';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.servicetime is '送达时间';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.servicedoc is '送达证';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.replydoc is '回执';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.filetype is '文件格式';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.filetype2 is '回执文件格式';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.tlrno is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.tlrdt is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.tlrtm is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.tlrjnlno is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.updt is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.uptm is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.isregister is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.openbr is '账户开户行';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.isdeal is '是否已处理 0-未处理 1-已处理';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.ischeck is '是否复核';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.isneed is '是否需要查询子户号 0-否 1-是';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.notifydoc is '文书名称';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.docnum is '文书文号';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.istransee is '是否调取电子证据 1-是 2-否';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.custnm is '户名';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.xtbz is '';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a77tfreezeqryusracct.etl_timestamp is 'ETL处理时间戳';
