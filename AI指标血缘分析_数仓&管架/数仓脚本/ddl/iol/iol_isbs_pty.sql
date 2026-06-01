/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_pty
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_pty
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_pty purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_pty(
    inr varchar2(12) -- 内部唯一id号
    ,extkey varchar2(36) -- 客户号
    ,nam varchar2(60) -- 客户名称
    ,ptytyp varchar2(23) -- 客户类型
    ,accusr varchar2(12) -- 用户帐户的id
    ,hbkaccflg varchar2(2) -- housebank帐户标志
    ,hbkconflg varchar2(2) -- housebank用户环境标志
    ,hbkinr varchar2(12) -- 银行inr
    ,heqaccflg varchar2(2) -- 总行帐户标志
    ,heqconflg varchar2(2) -- 总行环境标志
    ,heqinr varchar2(12) -- 总行inr
    ,prfctr varchar2(9) -- 收益中心
    ,resusr varchar2(12) -- 客户经理
    ,rskcls varchar2(9) -- 风险等级
    ,rskcty varchar2(3) -- 风险国家
    ,rsktxt varchar2(53) -- 风险文本描述
    ,uil varchar2(3) -- 传输的语言
    ,ver varchar2(6) -- 版本号
    ,akkbra varchar2(5) -- akk商业区域
    ,akkcom varchar2(12) -- akk公司id
    ,akkreg varchar2(3) -- akk地区编号
    ,lidcndflg varchar2(2) -- 特别l/c情况
    ,lidmaxdur number(4,0) -- l/c最大期限日
    ,trdcndflg varchar2(2) -- 特别交易情况
    ,trdtentot number(5,0) -- 汇票的最大期限日maximum
    ,trdtenini number(5,0) -- 最初汇票期限initial
    ,trdtenext number(5,0) -- 汇票的最大延期日maximum
    ,trdextnmb number(5,0) -- 汇票最大延期数
    ,badcndflg varchar2(2) -- 特别ba情况
    ,badtenext number(4,0) -- ba最大期限日
    ,adrsta varchar2(2) -- 地址状态
    ,seltyp varchar2(2) -- 客户信贷利率
    ,buytyp varchar2(2) -- 客户借贷利率
    ,sla varchar2(5) -- 服务等级
    ,etgextkey varchar2(12) -- 实体组
    ,nam1 varchar2(105) -- 中文名称chinese
    ,juscod varchar2(15) -- 技术监督局编号
    ,bilvvv number(8,5) -- 上浮比率
    ,cunqii varchar2(5) -- 流动资金贷款利率档次
    ,idcode varchar2(48) -- 身份证号码
    ,idtype varchar2(2) -- 客户类型
    ,bchkeyinr varchar2(12) -- 所属分行inr
    ,clscty varchar2(9) -- 国家的信用等级credit
    ,procod varchar2(3) -- 区域代码province
    ,trnman varchar2(3) -- 交易主体
    ,speeco varchar2(2) -- 特殊经济区域
    ,idtyp1 varchar2(6) -- id类型1
    ,ratstm varchar2(4000) -- 
    ,banktyp varchar2(5) -- 银行类型
    ,godcus varchar2(2) -- 
    ,imginr varchar2(12) -- 影像流水号
    ,bankno varchar2(30) -- 人行行号
    ,drccod varchar2(30) -- 所属直接参与机构
    ,bnkkey varchar2(48) -- 联系地址外部关键字
    ,bnkref varchar2(30) -- ECIF同业客户号
    ,risran varchar2(15) -- 反洗钱等级
    ,imginr2 varchar2(12) -- 新客户签约书
    ,risrantxt varchar2(765) -- 反洗钱等级描述
    ,idcodlst varchar2(300) -- 证件号码集合
    ,idtyplst varchar2(90) -- 证件类型集合
    ,iscrb varchar2(2) -- 跨境电商/跨境B2B
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
grant select on ${iol_schema}.isbs_pty to ${iml_schema};
grant select on ${iol_schema}.isbs_pty to ${icl_schema};
grant select on ${iol_schema}.isbs_pty to ${idl_schema};
grant select on ${iol_schema}.isbs_pty to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_pty is '当事人信息';
comment on column ${iol_schema}.isbs_pty.inr is '内部唯一id号';
comment on column ${iol_schema}.isbs_pty.extkey is '客户号';
comment on column ${iol_schema}.isbs_pty.nam is '客户名称';
comment on column ${iol_schema}.isbs_pty.ptytyp is '客户类型';
comment on column ${iol_schema}.isbs_pty.accusr is '用户帐户的id';
comment on column ${iol_schema}.isbs_pty.hbkaccflg is 'housebank帐户标志';
comment on column ${iol_schema}.isbs_pty.hbkconflg is 'housebank用户环境标志';
comment on column ${iol_schema}.isbs_pty.hbkinr is '银行inr';
comment on column ${iol_schema}.isbs_pty.heqaccflg is '总行帐户标志';
comment on column ${iol_schema}.isbs_pty.heqconflg is '总行环境标志';
comment on column ${iol_schema}.isbs_pty.heqinr is '总行inr';
comment on column ${iol_schema}.isbs_pty.prfctr is '收益中心';
comment on column ${iol_schema}.isbs_pty.resusr is '客户经理';
comment on column ${iol_schema}.isbs_pty.rskcls is '风险等级';
comment on column ${iol_schema}.isbs_pty.rskcty is '风险国家';
comment on column ${iol_schema}.isbs_pty.rsktxt is '风险文本描述';
comment on column ${iol_schema}.isbs_pty.uil is '传输的语言';
comment on column ${iol_schema}.isbs_pty.ver is '版本号';
comment on column ${iol_schema}.isbs_pty.akkbra is 'akk商业区域';
comment on column ${iol_schema}.isbs_pty.akkcom is 'akk公司id';
comment on column ${iol_schema}.isbs_pty.akkreg is 'akk地区编号';
comment on column ${iol_schema}.isbs_pty.lidcndflg is '特别l/c情况';
comment on column ${iol_schema}.isbs_pty.lidmaxdur is 'l/c最大期限日';
comment on column ${iol_schema}.isbs_pty.trdcndflg is '特别交易情况';
comment on column ${iol_schema}.isbs_pty.trdtentot is '汇票的最大期限日maximum';
comment on column ${iol_schema}.isbs_pty.trdtenini is '最初汇票期限initial';
comment on column ${iol_schema}.isbs_pty.trdtenext is '汇票的最大延期日maximum';
comment on column ${iol_schema}.isbs_pty.trdextnmb is '汇票最大延期数';
comment on column ${iol_schema}.isbs_pty.badcndflg is '特别ba情况';
comment on column ${iol_schema}.isbs_pty.badtenext is 'ba最大期限日';
comment on column ${iol_schema}.isbs_pty.adrsta is '地址状态';
comment on column ${iol_schema}.isbs_pty.seltyp is '客户信贷利率';
comment on column ${iol_schema}.isbs_pty.buytyp is '客户借贷利率';
comment on column ${iol_schema}.isbs_pty.sla is '服务等级';
comment on column ${iol_schema}.isbs_pty.etgextkey is '实体组';
comment on column ${iol_schema}.isbs_pty.nam1 is '中文名称chinese';
comment on column ${iol_schema}.isbs_pty.juscod is '技术监督局编号';
comment on column ${iol_schema}.isbs_pty.bilvvv is '上浮比率';
comment on column ${iol_schema}.isbs_pty.cunqii is '流动资金贷款利率档次';
comment on column ${iol_schema}.isbs_pty.idcode is '身份证号码';
comment on column ${iol_schema}.isbs_pty.idtype is '客户类型';
comment on column ${iol_schema}.isbs_pty.bchkeyinr is '所属分行inr';
comment on column ${iol_schema}.isbs_pty.clscty is '国家的信用等级credit';
comment on column ${iol_schema}.isbs_pty.procod is '区域代码province';
comment on column ${iol_schema}.isbs_pty.trnman is '交易主体';
comment on column ${iol_schema}.isbs_pty.speeco is '特殊经济区域';
comment on column ${iol_schema}.isbs_pty.idtyp1 is 'id类型1';
comment on column ${iol_schema}.isbs_pty.ratstm is '';
comment on column ${iol_schema}.isbs_pty.banktyp is '银行类型';
comment on column ${iol_schema}.isbs_pty.godcus is '';
comment on column ${iol_schema}.isbs_pty.imginr is '影像流水号';
comment on column ${iol_schema}.isbs_pty.bankno is '人行行号';
comment on column ${iol_schema}.isbs_pty.drccod is '所属直接参与机构';
comment on column ${iol_schema}.isbs_pty.bnkkey is '联系地址外部关键字';
comment on column ${iol_schema}.isbs_pty.bnkref is 'ECIF同业客户号';
comment on column ${iol_schema}.isbs_pty.risran is '反洗钱等级';
comment on column ${iol_schema}.isbs_pty.imginr2 is '新客户签约书';
comment on column ${iol_schema}.isbs_pty.risrantxt is '反洗钱等级描述';
comment on column ${iol_schema}.isbs_pty.idcodlst is '证件号码集合';
comment on column ${iol_schema}.isbs_pty.idtyplst is '证件类型集合';
comment on column ${iol_schema}.isbs_pty.iscrb is '跨境电商/跨境B2B';
comment on column ${iol_schema}.isbs_pty.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_pty.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_pty.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_pty.etl_timestamp is 'ETL处理时间戳';
