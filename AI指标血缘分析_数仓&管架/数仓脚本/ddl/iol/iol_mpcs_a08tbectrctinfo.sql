/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a08tbectrctinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a08tbectrctinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a08tbectrctinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbectrctinfo(
    transdt varchar2(12) -- 交易日期
    ,transtm varchar2(21) -- 交易时间
    ,ctrctsgndt varchar2(12) -- 协议签署日期
    ,ctrctnb varchar2(90) -- 协议号
    ,sndupbrn varchar2(21) -- 发起直接参与机构
    ,payflag varchar2(2) -- 收付款标识 p-付款方 r-收款方
    ,ctrcttp varchar2(6) -- 协议类型
    ,nbofpmtitms varchar2(3) -- 费项数目
    ,pmtitmcds varchar2(750) -- 费项代码集合
    ,cstmrid varchar2(48) -- 客户号
    ,cstmrnm varchar2(180) -- 客户名称
    ,payacct varchar2(48) -- 付款人账号
    ,payname varchar2(180) -- 付款人名称
    ,incoacct varchar2(48) -- 收款人账号
    ,inconame varchar2(180) -- 收款人名称
    ,cstmraccttype varchar2(6) -- 付款人账户类型
    ,payopenbrn varchar2(21) -- 付款人开户行
    ,idtp varchar2(6) -- 付款人证件类型
    ,id varchar2(53) -- 付款人证件号码
    ,telnb varchar2(45) -- 付款人手机号码(银行预留手机号码)
    ,adrline varchar2(180) -- 地址
    ,ctrctduedt varchar2(12) -- 协议到期日
    ,ectdt varchar2(12) -- 生效日期
    ,oncddctnlmt varchar2(33) -- 一次性扣款限额
    ,cycddctnnumlmt varchar2(12) -- 扣款周期内限制笔数
    ,cycddctnlmt varchar2(33) -- 扣款周期内扣费限额
    ,tmut varchar2(6) -- 扣款时间单位
    ,tmsp varchar2(5) -- 扣款时间步长
    ,tmdc varchar2(360) -- 扣款时间描述
    ,ctrctaddtlinf varchar2(3000) -- 协议附加数据
    ,signsts varchar2(2) -- 协议状态 z-初始登记 1-已生效 0-已失效 c-已撤销 w-待授权 r-被拒绝
    ,errmsg varchar2(750) -- 错误信息
    ,uptm varchar2(21) -- 更新时间
    ,authurl varchar2(1535) -- 认证url
    ,otpseqno varchar2(45) -- 短信认证流水
    ,regid varchar2(15) -- 区域标识
    ,paybrn varchar2(21) -- 付款行
    ,paybanknm varchar2(210) -- 付款行行名
    ,incobrn varchar2(21) -- 收款行
    ,incobanknm varchar2(210) -- 收款行行名
    ,unisoccdtcd varchar2(27) -- 统一社会信用代码
    ,iotype varchar2(2) -- 来往标识
    ,authmd varchar2(6) -- 授权模式
    ,magbrn varchar2(18) -- 处理机构
    ,remark varchar2(384) -- 附言
    ,dealflag varchar2(3) -- 全行处理标识
    ,openbrn varchar2(18) -- 开户机构
    ,brcno varchar2(9) -- 交易机构
    ,tlrno varchar2(18) -- 交易柜员
    ,authtlrno varchar2(18) -- 授权柜员号
    ,srcseqno varchar2(96) -- 原渠道流水
    ,mutrcd varchar2(30) -- 菜单码
    ,isstock varchar2(2) -- 是否为存量协议 1-是
    ,orictrctnb varchar2(90) -- 初始协议号
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
grant select on ${iol_schema}.mpcs_a08tbectrctinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a08tbectrctinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a08tbectrctinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a08tbectrctinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a08tbectrctinfo is '';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.transtm is '交易时间';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.ctrctsgndt is '协议签署日期';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.ctrctnb is '协议号';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.sndupbrn is '发起直接参与机构';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.payflag is '收付款标识 p-付款方 r-收款方';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.ctrcttp is '协议类型';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.nbofpmtitms is '费项数目';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.pmtitmcds is '费项代码集合';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.cstmrid is '客户号';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.cstmrnm is '客户名称';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.payacct is '付款人账号';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.payname is '付款人名称';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.incoacct is '收款人账号';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.inconame is '收款人名称';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.cstmraccttype is '付款人账户类型';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.payopenbrn is '付款人开户行';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.idtp is '付款人证件类型';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.id is '付款人证件号码';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.telnb is '付款人手机号码(银行预留手机号码)';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.adrline is '地址';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.ctrctduedt is '协议到期日';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.ectdt is '生效日期';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.oncddctnlmt is '一次性扣款限额';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.cycddctnnumlmt is '扣款周期内限制笔数';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.cycddctnlmt is '扣款周期内扣费限额';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.tmut is '扣款时间单位';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.tmsp is '扣款时间步长';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.tmdc is '扣款时间描述';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.ctrctaddtlinf is '协议附加数据';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.signsts is '协议状态 z-初始登记 1-已生效 0-已失效 c-已撤销 w-待授权 r-被拒绝';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.uptm is '更新时间';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.authurl is '认证url';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.otpseqno is '短信认证流水';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.regid is '区域标识';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.paybrn is '付款行';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.paybanknm is '付款行行名';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.incobrn is '收款行';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.incobanknm is '收款行行名';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.unisoccdtcd is '统一社会信用代码';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.iotype is '来往标识';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.authmd is '授权模式';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.magbrn is '处理机构';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.remark is '附言';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.dealflag is '全行处理标识';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.openbrn is '开户机构';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.brcno is '交易机构';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.tlrno is '交易柜员';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.authtlrno is '授权柜员号';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.srcseqno is '原渠道流水';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.mutrcd is '菜单码';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.isstock is '是否为存量协议 1-是';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.orictrctnb is '初始协议号';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a08tbectrctinfo.etl_timestamp is 'ETL处理时间戳';
