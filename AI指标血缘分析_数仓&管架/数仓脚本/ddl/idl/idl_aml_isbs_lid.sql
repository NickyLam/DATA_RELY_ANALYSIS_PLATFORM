/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_lid
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_lid
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_lid purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_lid(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 进口信用证ID号
    ,ownref varchar2(16) -- 参考号
    ,nam varchar2(40) -- 标识交易的外部显示名称
    ,ownusr varchar2(8) -- 参考号
    ,credat date -- 开证或注册日期
    ,opndat date -- 开证日期
    ,clsdat date -- 结束日期
    ,advnam varchar2(40) -- 通知行名称
    ,advref varchar2(16) -- 通知行参考号
    ,amedat date -- 上次修改日期
    ,amenbr number(2) -- 修改次数
    ,aplnam varchar2(40) -- 申请人名称
    ,aplref varchar2(16) -- 申请人参考号
    ,avbby varchar2(1) -- 指定方式
    ,avbwth varchar2(1) -- 指定方式
    ,bennam varchar2(40) -- 收益人名字
    ,benref varchar2(16) -- 受益人参考号
    ,chato varchar2(1) -- 费用流向
    ,cnfdet varchar2(1) -- 保兑状态
    ,expdat date -- 效期，指定信用证的效期
    ,expplc varchar2(29) -- 交单地点
    ,lcrtyp varchar2(2) -- 信用证的格式
    ,nomspc varchar2(1) -- 规格数量
    ,nomtop number(2) -- 溢短装
    ,nomton number(2) -- 溢短装
    ,preadvdt date -- 预通知日期
    ,rmbact varchar2(35) -- 偿付行用户帐号
    ,rmbcha varchar2(3) -- 偿付行费用
    ,rmbflg varchar2(1) -- 偿付标志
    ,shpdat date -- 装船日期
    ,shpfro varchar2(65) -- 装船地点
    ,porloa varchar2(65) -- 装货港
    ,pordis varchar2(65) -- 卸货港
    ,shppar varchar2(35) -- 分装
    ,shpto varchar2(65) -- 运货地点
    ,shptrs varchar2(35) -- 转载[SHPTRS]
    ,stacty varchar2(2) -- 国家代码
    ,stagod varchar2(6) -- 货物代码
    ,utlnbr number(3) -- 利用数目
    ,advnbr number(3) -- 通知次数
    ,redclsflg varchar2(1) -- 红/绿
    ,ver varchar2(4) -- 版本号
    ,lcityp varchar2(1) -- 信用证类型
    ,b2binr varchar2(8) -- 背对背信用证INR
    ,b2bref varchar2(16) -- 背对背信用证参考号
    ,revnbr number(2) -- 循环实际次数
    ,revtimes number(2) -- 循环允许最大次数
    ,revflg varchar2(1) -- 循环标志
    ,revawapl varchar2(1) -- 等待申请人回复标志
    ,revdat date -- 循环日期
    ,revcum varchar2(1) -- 累计记贷
    ,revtyp varchar2(40) -- 循环方式
    ,initpty varchar2(3) -- 申请人所在银行
    ,resflg varchar2(1) -- 预留标志
    ,apprul varchar2(30) -- 适用的惯例
    ,apprulrmb varchar2(30) -- 适用的偿付惯例
    ,apprultxt varchar2(35) -- 其他惯例
    ,autdat date -- 偿付日期
    ,etyextkey varchar2(8) -- 交易实体
    ,tenmaxday number(3) -- 远期期限
    ,branchinr varchar2(8) -- 所属机构号
    ,bchkeyinr varchar2(8) -- 经办机构号
    ,decflg varchar2(1) -- 存在减额修改标志
    ,cshpct number(5,2) -- 保证金应收比例
    ,isstyp varchar2(1) -- 发布类型
    ,fincod varchar2(32) -- 借据号
    ,fintyp varchar2(7) -- 业务品种
    ,relcshpct number(7,2) -- 保证金实收比例
    ,jjh varchar2(24) -- 借据号
    ,dflg varchar2(1) -- 国内信用证标志
    ,guaflg varchar2(1) -- 押货标志
    ,tratyp varchar2(2) -- 运输方式
    ,opnamo number(18,3) -- 信用证余额
    ,ameflg varchar2(10) -- 修改标志
    ,cretyp varchar2(1) -- 
    ,tadtyp varchar2(10) -- 
    ,shpins varchar2(35) -- 
    ,sermod varchar2(65) -- 
    ,serfro varchar2(65) -- 
    ,negflg varchar2(5) -- 
    ,comflg varchar2(5) -- 
    ,insdat varchar2(40) -- 
    ,shppars18 varchar2(11) -- 装船日期
    ,shptrss18 varchar2(11) -- 选择是否拆装
    ,spcbenflg varchar2(1) -- 受益人特殊付款条件标记
    ,spcrcbflg varchar2(1) -- 收款行特殊付款条件标记
    ,prepertxts18 varchar2(35) -- 提示周期
    ,prepers18 number(3) -- 周期描述
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_isbs_lid to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_lid is '进口信用证业务信息(存放短字节)';
comment on column ${idl_schema}.aml_isbs_lid.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_lid.inr is '进口信用证ID号';
comment on column ${idl_schema}.aml_isbs_lid.ownref is '参考号';
comment on column ${idl_schema}.aml_isbs_lid.nam is '标识交易的外部显示名称';
comment on column ${idl_schema}.aml_isbs_lid.ownusr is '参考号';
comment on column ${idl_schema}.aml_isbs_lid.credat is '开证或注册日期';
comment on column ${idl_schema}.aml_isbs_lid.opndat is '开证日期';
comment on column ${idl_schema}.aml_isbs_lid.clsdat is '结束日期';
comment on column ${idl_schema}.aml_isbs_lid.advnam is '通知行名称';
comment on column ${idl_schema}.aml_isbs_lid.advref is '通知行参考号';
comment on column ${idl_schema}.aml_isbs_lid.amedat is '上次修改日期';
comment on column ${idl_schema}.aml_isbs_lid.amenbr is '修改次数';
comment on column ${idl_schema}.aml_isbs_lid.aplnam is '申请人名称';
comment on column ${idl_schema}.aml_isbs_lid.aplref is '申请人参考号';
comment on column ${idl_schema}.aml_isbs_lid.avbby is '指定方式';
comment on column ${idl_schema}.aml_isbs_lid.avbwth is '指定方式';
comment on column ${idl_schema}.aml_isbs_lid.bennam is '收益人名字';
comment on column ${idl_schema}.aml_isbs_lid.benref is '受益人参考号';
comment on column ${idl_schema}.aml_isbs_lid.chato is '费用流向';
comment on column ${idl_schema}.aml_isbs_lid.cnfdet is '保兑状态';
comment on column ${idl_schema}.aml_isbs_lid.expdat is '效期，指定信用证的效期';
comment on column ${idl_schema}.aml_isbs_lid.expplc is '交单地点';
comment on column ${idl_schema}.aml_isbs_lid.lcrtyp is '信用证的格式';
comment on column ${idl_schema}.aml_isbs_lid.nomspc is '规格数量';
comment on column ${idl_schema}.aml_isbs_lid.nomtop is '溢短装';
comment on column ${idl_schema}.aml_isbs_lid.nomton is '溢短装';
comment on column ${idl_schema}.aml_isbs_lid.preadvdt is '预通知日期';
comment on column ${idl_schema}.aml_isbs_lid.rmbact is '偿付行用户帐号';
comment on column ${idl_schema}.aml_isbs_lid.rmbcha is '偿付行费用';
comment on column ${idl_schema}.aml_isbs_lid.rmbflg is '偿付标志';
comment on column ${idl_schema}.aml_isbs_lid.shpdat is '装船日期';
comment on column ${idl_schema}.aml_isbs_lid.shpfro is '装船地点';
comment on column ${idl_schema}.aml_isbs_lid.porloa is '装货港';
comment on column ${idl_schema}.aml_isbs_lid.pordis is '卸货港';
comment on column ${idl_schema}.aml_isbs_lid.shppar is '分装';
comment on column ${idl_schema}.aml_isbs_lid.shpto is '运货地点';
comment on column ${idl_schema}.aml_isbs_lid.shptrs is '转载[SHPTRS]';
comment on column ${idl_schema}.aml_isbs_lid.stacty is '国家代码';
comment on column ${idl_schema}.aml_isbs_lid.stagod is '货物代码';
comment on column ${idl_schema}.aml_isbs_lid.utlnbr is '利用数目';
comment on column ${idl_schema}.aml_isbs_lid.advnbr is '通知次数';
comment on column ${idl_schema}.aml_isbs_lid.redclsflg is '红/绿';
comment on column ${idl_schema}.aml_isbs_lid.ver is '版本号';
comment on column ${idl_schema}.aml_isbs_lid.lcityp is '信用证类型';
comment on column ${idl_schema}.aml_isbs_lid.b2binr is '背对背信用证INR';
comment on column ${idl_schema}.aml_isbs_lid.b2bref is '背对背信用证参考号';
comment on column ${idl_schema}.aml_isbs_lid.revnbr is '循环实际次数';
comment on column ${idl_schema}.aml_isbs_lid.revtimes is '循环允许最大次数';
comment on column ${idl_schema}.aml_isbs_lid.revflg is '循环标志';
comment on column ${idl_schema}.aml_isbs_lid.revawapl is '等待申请人回复标志';
comment on column ${idl_schema}.aml_isbs_lid.revdat is '循环日期';
comment on column ${idl_schema}.aml_isbs_lid.revcum is '累计记贷';
comment on column ${idl_schema}.aml_isbs_lid.revtyp is '循环方式';
comment on column ${idl_schema}.aml_isbs_lid.initpty is '申请人所在银行';
comment on column ${idl_schema}.aml_isbs_lid.resflg is '预留标志';
comment on column ${idl_schema}.aml_isbs_lid.apprul is '适用的惯例';
comment on column ${idl_schema}.aml_isbs_lid.apprulrmb is '适用的偿付惯例';
comment on column ${idl_schema}.aml_isbs_lid.apprultxt is '其他惯例';
comment on column ${idl_schema}.aml_isbs_lid.autdat is '偿付日期';
comment on column ${idl_schema}.aml_isbs_lid.etyextkey is '交易实体';
comment on column ${idl_schema}.aml_isbs_lid.tenmaxday is '远期期限';
comment on column ${idl_schema}.aml_isbs_lid.branchinr is '所属机构号';
comment on column ${idl_schema}.aml_isbs_lid.bchkeyinr is '经办机构号';
comment on column ${idl_schema}.aml_isbs_lid.decflg is '存在减额修改标志';
comment on column ${idl_schema}.aml_isbs_lid.cshpct is '保证金应收比例';
comment on column ${idl_schema}.aml_isbs_lid.isstyp is '发布类型';
comment on column ${idl_schema}.aml_isbs_lid.fincod is '借据号';
comment on column ${idl_schema}.aml_isbs_lid.fintyp is '业务品种';
comment on column ${idl_schema}.aml_isbs_lid.relcshpct is '保证金实收比例';
comment on column ${idl_schema}.aml_isbs_lid.jjh is '借据号';
comment on column ${idl_schema}.aml_isbs_lid.dflg is '国内信用证标志';
comment on column ${idl_schema}.aml_isbs_lid.guaflg is '押货标志';
comment on column ${idl_schema}.aml_isbs_lid.tratyp is '运输方式';
comment on column ${idl_schema}.aml_isbs_lid.opnamo is '信用证余额';
comment on column ${idl_schema}.aml_isbs_lid.ameflg is '修改标志';
comment on column ${idl_schema}.aml_isbs_lid.cretyp is '';
comment on column ${idl_schema}.aml_isbs_lid.tadtyp is '';
comment on column ${idl_schema}.aml_isbs_lid.shpins is '';
comment on column ${idl_schema}.aml_isbs_lid.sermod is '';
comment on column ${idl_schema}.aml_isbs_lid.serfro is '';
comment on column ${idl_schema}.aml_isbs_lid.negflg is '';
comment on column ${idl_schema}.aml_isbs_lid.comflg is '';
comment on column ${idl_schema}.aml_isbs_lid.insdat is '';
comment on column ${idl_schema}.aml_isbs_lid.shppars18 is '装船日期';
comment on column ${idl_schema}.aml_isbs_lid.shptrss18 is '选择是否拆装';
comment on column ${idl_schema}.aml_isbs_lid.spcbenflg is '受益人特殊付款条件标记';
comment on column ${idl_schema}.aml_isbs_lid.spcrcbflg is '收款行特殊付款条件标记';
comment on column ${idl_schema}.aml_isbs_lid.prepertxts18 is '提示周期';
comment on column ${idl_schema}.aml_isbs_lid.prepers18 is '周期描述';
comment on column ${idl_schema}.aml_isbs_lid.etl_timestamp is '数据处理时间';
