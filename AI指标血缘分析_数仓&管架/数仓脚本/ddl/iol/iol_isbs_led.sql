/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_led
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_led
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_led purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_led(
    inr varchar2(12) -- 出口信用证id号
    ,ownref varchar2(24) -- 参考号
    ,nam varchar2(60) -- 标识交易的外部显示名称
    ,ownusr varchar2(12) -- 经办人
    ,credat date -- 创建日期
    ,opndat date -- 开证日期, 指定信用证被开证行开出的日期
    ,clsdat date -- 关闭日期
    ,cnfdat date -- 保兑日
    ,advdat date -- 通知日期
    ,issnam varchar2(60) -- 开证行
    ,issref varchar2(24) -- 开证行参考号
    ,amedat date -- 修改日期
    ,amenbr number(3,0) -- 修改次数
    ,avbby varchar2(2) -- 单据处理方式
    ,avbwth varchar2(2) -- 单据处理行
    ,bennam varchar2(60) -- 受益人
    ,benref varchar2(24) -- 受益人参考号
    ,chato varchar2(2) -- 费用分担
    ,cnfflg varchar2(2) -- 承兑类型
    ,cnfdet varchar2(2) -- 开证行保兑状态
    ,cnfsta varchar2(2) -- 保兑状态’y’,’s’,’ ’
    ,expdat date -- 出口日期
    ,expplc varchar2(44) -- 交易完成地点
    ,lcrtyp varchar2(3) -- 付款种类
    ,nomspc varchar2(2) -- 溢短装标志。
    ,nomtop number(2,0) -- 溢短装-正
    ,nomton number(2,0) -- 溢短装-负
    ,preadvdt date -- 预通知日期
    ,shpdat date -- 装船日期，指定装船的最后日期
    ,shpfro varchar2(213) -- 装船地点
    ,shppar varchar2(53) -- 运货地点
    ,shpto varchar2(213) -- 运货地点
    ,shptrs varchar2(53) -- 转载
    ,stacty varchar2(3) -- 国家代码
    ,stagod varchar2(9) -- 货物代码
    ,utlnbr number(3,0) -- 利用数目
    ,ver varchar2(6) -- 版本号
    ,aplbnkdirsnd varchar2(2) -- 是否立即发送
    ,tenmaxday number(4,0) -- 最大期限
    ,cnfsnd varchar2(2) -- 第一通知行保兑状态
    ,revflg varchar2(2) -- 循环标志
    ,revnbr number(2,0) -- 循环信用证号
    ,revtimes number(2,0) -- 循环次数
    ,revdat date -- 到单日
    ,revcum varchar2(2) -- 累计记贷
    ,revtyp varchar2(60) -- 循环类型
    ,cnfins varchar2(2) -- 发给第二通知行确认栏位
    ,redclsflg varchar2(2) -- 红/绿 条款
    ,advnbr number(3,0) -- 通知次数
    ,resflg varchar2(2) -- 预留标志
    ,inctrf varchar2(2) -- 开入的装让标志
    ,apprul varchar2(45) -- 适用的条款
    ,apprultxt varchar2(53) -- 其他适用的条款
    ,pordis varchar2(213) -- 卸货港口
    ,porloa varchar2(213) -- 部分装船
    ,nonban varchar2(2) -- 与银行无关的开证人标志
    ,etyextkey varchar2(12) -- 默认/初始用户id
    ,partcon number(5,2) -- 保兑百分比
    ,collflg varchar2(2) -- 信用证抵押标志位
    ,teskeyunc varchar2(2) -- 检验是否确认
    ,dbtflg varchar2(2) -- 记入借方授权标志
    ,branchinr varchar2(12) -- 所属机构号
    ,bchkeyinr varchar2(12) -- 经办机构号
    ,rskrat number(3,2) -- 风险额度占用率
    ,dflg varchar2(2) -- dflg
    ,tratyp varchar2(3) -- 运输方式
    ,negflg varchar2(3) -- 
    ,shppars18 varchar2(17) -- 
    ,prepers18 number(3,0) -- 
    ,prepertxts18 varchar2(53) -- 
    ,shptrss18 varchar2(17) -- 
    ,spcbenflg varchar2(2) -- 
    ,spcrcbflg varchar2(2) -- 
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
grant select on ${iol_schema}.isbs_led to ${iml_schema};
grant select on ${iol_schema}.isbs_led to ${icl_schema};
grant select on ${iol_schema}.isbs_led to ${idl_schema};
grant select on ${iol_schema}.isbs_led to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_led is '出口信用证业务信息(存放短字节)';
comment on column ${iol_schema}.isbs_led.inr is '出口信用证id号';
comment on column ${iol_schema}.isbs_led.ownref is '参考号';
comment on column ${iol_schema}.isbs_led.nam is '标识交易的外部显示名称';
comment on column ${iol_schema}.isbs_led.ownusr is '经办人';
comment on column ${iol_schema}.isbs_led.credat is '创建日期';
comment on column ${iol_schema}.isbs_led.opndat is '开证日期, 指定信用证被开证行开出的日期';
comment on column ${iol_schema}.isbs_led.clsdat is '关闭日期';
comment on column ${iol_schema}.isbs_led.cnfdat is '保兑日';
comment on column ${iol_schema}.isbs_led.advdat is '通知日期';
comment on column ${iol_schema}.isbs_led.issnam is '开证行';
comment on column ${iol_schema}.isbs_led.issref is '开证行参考号';
comment on column ${iol_schema}.isbs_led.amedat is '修改日期';
comment on column ${iol_schema}.isbs_led.amenbr is '修改次数';
comment on column ${iol_schema}.isbs_led.avbby is '单据处理方式';
comment on column ${iol_schema}.isbs_led.avbwth is '单据处理行';
comment on column ${iol_schema}.isbs_led.bennam is '受益人';
comment on column ${iol_schema}.isbs_led.benref is '受益人参考号';
comment on column ${iol_schema}.isbs_led.chato is '费用分担';
comment on column ${iol_schema}.isbs_led.cnfflg is '承兑类型';
comment on column ${iol_schema}.isbs_led.cnfdet is '开证行保兑状态';
comment on column ${iol_schema}.isbs_led.cnfsta is '保兑状态’y’,’s’,’ ’';
comment on column ${iol_schema}.isbs_led.expdat is '出口日期';
comment on column ${iol_schema}.isbs_led.expplc is '交易完成地点';
comment on column ${iol_schema}.isbs_led.lcrtyp is '付款种类';
comment on column ${iol_schema}.isbs_led.nomspc is '溢短装标志。';
comment on column ${iol_schema}.isbs_led.nomtop is '溢短装-正';
comment on column ${iol_schema}.isbs_led.nomton is '溢短装-负';
comment on column ${iol_schema}.isbs_led.preadvdt is '预通知日期';
comment on column ${iol_schema}.isbs_led.shpdat is '装船日期，指定装船的最后日期';
comment on column ${iol_schema}.isbs_led.shpfro is '装船地点';
comment on column ${iol_schema}.isbs_led.shppar is '运货地点';
comment on column ${iol_schema}.isbs_led.shpto is '运货地点';
comment on column ${iol_schema}.isbs_led.shptrs is '转载';
comment on column ${iol_schema}.isbs_led.stacty is '国家代码';
comment on column ${iol_schema}.isbs_led.stagod is '货物代码';
comment on column ${iol_schema}.isbs_led.utlnbr is '利用数目';
comment on column ${iol_schema}.isbs_led.ver is '版本号';
comment on column ${iol_schema}.isbs_led.aplbnkdirsnd is '是否立即发送';
comment on column ${iol_schema}.isbs_led.tenmaxday is '最大期限';
comment on column ${iol_schema}.isbs_led.cnfsnd is '第一通知行保兑状态';
comment on column ${iol_schema}.isbs_led.revflg is '循环标志';
comment on column ${iol_schema}.isbs_led.revnbr is '循环信用证号';
comment on column ${iol_schema}.isbs_led.revtimes is '循环次数';
comment on column ${iol_schema}.isbs_led.revdat is '到单日';
comment on column ${iol_schema}.isbs_led.revcum is '累计记贷';
comment on column ${iol_schema}.isbs_led.revtyp is '循环类型';
comment on column ${iol_schema}.isbs_led.cnfins is '发给第二通知行确认栏位';
comment on column ${iol_schema}.isbs_led.redclsflg is '红/绿 条款';
comment on column ${iol_schema}.isbs_led.advnbr is '通知次数';
comment on column ${iol_schema}.isbs_led.resflg is '预留标志';
comment on column ${iol_schema}.isbs_led.inctrf is '开入的装让标志';
comment on column ${iol_schema}.isbs_led.apprul is '适用的条款';
comment on column ${iol_schema}.isbs_led.apprultxt is '其他适用的条款';
comment on column ${iol_schema}.isbs_led.pordis is '卸货港口';
comment on column ${iol_schema}.isbs_led.porloa is '部分装船';
comment on column ${iol_schema}.isbs_led.nonban is '与银行无关的开证人标志';
comment on column ${iol_schema}.isbs_led.etyextkey is '默认/初始用户id';
comment on column ${iol_schema}.isbs_led.partcon is '保兑百分比';
comment on column ${iol_schema}.isbs_led.collflg is '信用证抵押标志位';
comment on column ${iol_schema}.isbs_led.teskeyunc is '检验是否确认';
comment on column ${iol_schema}.isbs_led.dbtflg is '记入借方授权标志';
comment on column ${iol_schema}.isbs_led.branchinr is '所属机构号';
comment on column ${iol_schema}.isbs_led.bchkeyinr is '经办机构号';
comment on column ${iol_schema}.isbs_led.rskrat is '风险额度占用率';
comment on column ${iol_schema}.isbs_led.dflg is 'dflg';
comment on column ${iol_schema}.isbs_led.tratyp is '运输方式';
comment on column ${iol_schema}.isbs_led.negflg is '';
comment on column ${iol_schema}.isbs_led.shppars18 is '';
comment on column ${iol_schema}.isbs_led.prepers18 is '';
comment on column ${iol_schema}.isbs_led.prepertxts18 is '';
comment on column ${iol_schema}.isbs_led.shptrss18 is '';
comment on column ${iol_schema}.isbs_led.spcbenflg is '';
comment on column ${iol_schema}.isbs_led.spcrcbflg is '';
comment on column ${iol_schema}.isbs_led.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_led.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_led.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_led.etl_timestamp is 'ETL处理时间戳';
