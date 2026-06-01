/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_led
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_led
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_led purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_led(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 出口信用证ID号
    ,ownref varchar2(16) -- 参考号
    ,nam varchar2(40) -- 标识交易的外部显示名称
    ,ownusr varchar2(8) -- 经办人
    ,credat date -- 创建日期
    ,opndat date -- 开证日期, 指定信用证被开证行开出的日期
    ,clsdat date -- 关闭日期
    ,cnfdat date -- 保兑日
    ,advdat date -- 通知日期
    ,issnam varchar2(40) -- 开证行
    ,issref varchar2(16) -- 开证行参考号
    ,amedat date -- 修改日期
    ,amenbr number(3) -- 修改次数
    ,avbby varchar2(1) -- 单据处理方式
    ,avbwth varchar2(1) -- 单据处理行
    ,bennam varchar2(40) -- 受益人
    ,benref varchar2(16) -- 受益人参考号
    ,chato varchar2(1) -- 费用分担
    ,cnfflg varchar2(1) -- 承兑类型
    ,cnfdet varchar2(1) -- 开证行保兑状态
    ,cnfsta varchar2(1) -- 保兑状态’Y’,’S’,’ ’
    ,expdat date -- 出口日期
    ,expplc varchar2(29) -- 交易完成地点
    ,lcrtyp varchar2(2) -- 付款种类
    ,nomspc varchar2(1) -- 溢短装标志。
    ,nomtop number(2) -- 溢短装-正
    ,nomton number(2) -- 溢短装-负
    ,preadvdt date -- 预通知日期
    ,shpdat date -- 装船日期，指定装船的最后日期
    ,shpfro varchar2(65) -- 装船地点
    ,shppar varchar2(35) -- 运货地点
    ,shpto varchar2(65) -- 运货地点
    ,shptrs varchar2(35) -- 转载
    ,stacty varchar2(2) -- 国家代码
    ,stagod varchar2(6) -- 货物代码
    ,utlnbr number(3) -- 利用数目
    ,ver varchar2(4) -- 版本号
    ,aplbnkdirsnd varchar2(1) -- 是否立即发送
    ,tenmaxday number(4) -- 最大期限
    ,cnfsnd varchar2(1) -- 第一通知行保兑状态
    ,revflg varchar2(1) -- 循环标志
    ,revnbr number(2) -- 循环信用证号
    ,revtimes number(2) -- 循环次数
    ,revdat date -- 到单日
    ,revcum varchar2(1) -- 累计记贷
    ,revtyp varchar2(40) -- 循环类型
    ,cnfins varchar2(1) -- 发给第二通知行确认栏位
    ,redclsflg varchar2(1) -- 红/绿 条款
    ,advnbr number(3) -- 通知次数
    ,resflg varchar2(1) -- 预留标志
    ,inctrf varchar2(1) -- 开入的装让标志
    ,apprul varchar2(30) -- 适用的条款
    ,apprultxt varchar2(35) -- 其他适用的条款
    ,pordis varchar2(65) -- 卸货港口
    ,porloa varchar2(65) -- 部分装船
    ,nonban varchar2(1) -- 与银行无关的开证人标志
    ,etyextkey varchar2(8) -- 默认/初始用户ID
    ,partcon number(5,2) -- 保兑百分比
    ,collflg varchar2(1) -- 信用证抵押标志位
    ,teskeyunc varchar2(1) -- 检验是否确认
    ,dbtflg varchar2(1) -- 记入借方授权标志
    ,branchinr varchar2(8) -- 所属机构号
    ,bchkeyinr varchar2(8) -- 经办机构号
    ,rskrat number(3,2) -- 风险额度占用率
    ,dflg varchar2(1) -- dflg
    ,tratyp varchar2(2) -- 运输方式
    ,negflg varchar2(2) -- 
    ,shppars18 varchar2(11) -- 装船日期
    ,prepers18 number(3) -- 周期描述
    ,prepertxts18 varchar2(35) -- 提示周期
    ,shptrss18 varchar2(11) -- 选择是否拆装
    ,spcbenflg varchar2(1) -- 受益人特殊付款条件标记
    ,spcrcbflg varchar2(1) -- 收款行特殊付款条件标记
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
grant select on ${idl_schema}.aml_isbs_led to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_led is '出口信用证业务信息(存放短字节)';
comment on column ${idl_schema}.aml_isbs_led.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_led.inr is '出口信用证ID号';
comment on column ${idl_schema}.aml_isbs_led.ownref is '参考号';
comment on column ${idl_schema}.aml_isbs_led.nam is '标识交易的外部显示名称';
comment on column ${idl_schema}.aml_isbs_led.ownusr is '经办人';
comment on column ${idl_schema}.aml_isbs_led.credat is '创建日期';
comment on column ${idl_schema}.aml_isbs_led.opndat is '开证日期, 指定信用证被开证行开出的日期';
comment on column ${idl_schema}.aml_isbs_led.clsdat is '关闭日期';
comment on column ${idl_schema}.aml_isbs_led.cnfdat is '保兑日';
comment on column ${idl_schema}.aml_isbs_led.advdat is '通知日期';
comment on column ${idl_schema}.aml_isbs_led.issnam is '开证行';
comment on column ${idl_schema}.aml_isbs_led.issref is '开证行参考号';
comment on column ${idl_schema}.aml_isbs_led.amedat is '修改日期';
comment on column ${idl_schema}.aml_isbs_led.amenbr is '修改次数';
comment on column ${idl_schema}.aml_isbs_led.avbby is '单据处理方式';
comment on column ${idl_schema}.aml_isbs_led.avbwth is '单据处理行';
comment on column ${idl_schema}.aml_isbs_led.bennam is '受益人';
comment on column ${idl_schema}.aml_isbs_led.benref is '受益人参考号';
comment on column ${idl_schema}.aml_isbs_led.chato is '费用分担';
comment on column ${idl_schema}.aml_isbs_led.cnfflg is '承兑类型';
comment on column ${idl_schema}.aml_isbs_led.cnfdet is '开证行保兑状态';
comment on column ${idl_schema}.aml_isbs_led.cnfsta is '保兑状态’Y’,’S’,’ ’';
comment on column ${idl_schema}.aml_isbs_led.expdat is '出口日期';
comment on column ${idl_schema}.aml_isbs_led.expplc is '交易完成地点';
comment on column ${idl_schema}.aml_isbs_led.lcrtyp is '付款种类';
comment on column ${idl_schema}.aml_isbs_led.nomspc is '溢短装标志。';
comment on column ${idl_schema}.aml_isbs_led.nomtop is '溢短装-正';
comment on column ${idl_schema}.aml_isbs_led.nomton is '溢短装-负';
comment on column ${idl_schema}.aml_isbs_led.preadvdt is '预通知日期';
comment on column ${idl_schema}.aml_isbs_led.shpdat is '装船日期，指定装船的最后日期';
comment on column ${idl_schema}.aml_isbs_led.shpfro is '装船地点';
comment on column ${idl_schema}.aml_isbs_led.shppar is '运货地点';
comment on column ${idl_schema}.aml_isbs_led.shpto is '运货地点';
comment on column ${idl_schema}.aml_isbs_led.shptrs is '转载';
comment on column ${idl_schema}.aml_isbs_led.stacty is '国家代码';
comment on column ${idl_schema}.aml_isbs_led.stagod is '货物代码';
comment on column ${idl_schema}.aml_isbs_led.utlnbr is '利用数目';
comment on column ${idl_schema}.aml_isbs_led.ver is '版本号';
comment on column ${idl_schema}.aml_isbs_led.aplbnkdirsnd is '是否立即发送';
comment on column ${idl_schema}.aml_isbs_led.tenmaxday is '最大期限';
comment on column ${idl_schema}.aml_isbs_led.cnfsnd is '第一通知行保兑状态';
comment on column ${idl_schema}.aml_isbs_led.revflg is '循环标志';
comment on column ${idl_schema}.aml_isbs_led.revnbr is '循环信用证号';
comment on column ${idl_schema}.aml_isbs_led.revtimes is '循环次数';
comment on column ${idl_schema}.aml_isbs_led.revdat is '到单日';
comment on column ${idl_schema}.aml_isbs_led.revcum is '累计记贷';
comment on column ${idl_schema}.aml_isbs_led.revtyp is '循环类型';
comment on column ${idl_schema}.aml_isbs_led.cnfins is '发给第二通知行确认栏位';
comment on column ${idl_schema}.aml_isbs_led.redclsflg is '红/绿 条款';
comment on column ${idl_schema}.aml_isbs_led.advnbr is '通知次数';
comment on column ${idl_schema}.aml_isbs_led.resflg is '预留标志';
comment on column ${idl_schema}.aml_isbs_led.inctrf is '开入的装让标志';
comment on column ${idl_schema}.aml_isbs_led.apprul is '适用的条款';
comment on column ${idl_schema}.aml_isbs_led.apprultxt is '其他适用的条款';
comment on column ${idl_schema}.aml_isbs_led.pordis is '卸货港口';
comment on column ${idl_schema}.aml_isbs_led.porloa is '部分装船';
comment on column ${idl_schema}.aml_isbs_led.nonban is '与银行无关的开证人标志';
comment on column ${idl_schema}.aml_isbs_led.etyextkey is '默认/初始用户ID';
comment on column ${idl_schema}.aml_isbs_led.partcon is '保兑百分比';
comment on column ${idl_schema}.aml_isbs_led.collflg is '信用证抵押标志位';
comment on column ${idl_schema}.aml_isbs_led.teskeyunc is '检验是否确认';
comment on column ${idl_schema}.aml_isbs_led.dbtflg is '记入借方授权标志';
comment on column ${idl_schema}.aml_isbs_led.branchinr is '所属机构号';
comment on column ${idl_schema}.aml_isbs_led.bchkeyinr is '经办机构号';
comment on column ${idl_schema}.aml_isbs_led.rskrat is '风险额度占用率';
comment on column ${idl_schema}.aml_isbs_led.dflg is 'dflg';
comment on column ${idl_schema}.aml_isbs_led.tratyp is '运输方式';
comment on column ${idl_schema}.aml_isbs_led.negflg is '';
comment on column ${idl_schema}.aml_isbs_led.shppars18 is '装船日期';
comment on column ${idl_schema}.aml_isbs_led.prepers18 is '周期描述';
comment on column ${idl_schema}.aml_isbs_led.prepertxts18 is '提示周期';
comment on column ${idl_schema}.aml_isbs_led.shptrss18 is '选择是否拆装';
comment on column ${idl_schema}.aml_isbs_led.spcbenflg is '受益人特殊付款条件标记';
comment on column ${idl_schema}.aml_isbs_led.spcrcbflg is '收款行特殊付款条件标记';
comment on column ${idl_schema}.aml_isbs_led.etl_timestamp is '数据处理时间';
