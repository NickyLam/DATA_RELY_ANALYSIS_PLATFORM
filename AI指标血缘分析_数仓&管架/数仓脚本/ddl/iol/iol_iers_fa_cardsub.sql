/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol iers_fa_cardsub
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.iers_fa_cardsub
whenever sqlerror continue none;
drop table ${iol_schema}.iers_fa_cardsub purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fa_cardsub(
    def1 varchar2(152) -- 资产序号
    ,def10 varchar2(152) -- 序列号
    ,def11 varchar2(152) -- 自定义项11
    ,def12 varchar2(152) -- 自定义项12
    ,def13 varchar2(152) -- 自定义项13
    ,def14 varchar2(152) -- 自定义项14
    ,def15 varchar2(152) -- 自定义项15
    ,def16 varchar2(152) -- 自定义项16
    ,def17 varchar2(152) -- 自定义项17
    ,def18 varchar2(152) -- 自定义项18
    ,def19 varchar2(152) -- 评估余额
    ,def2 varchar2(152) -- 自定义项2
    ,def20 varchar2(152) -- 存放地点
    ,def21 varchar2(152) -- 自定义项21
    ,def22 varchar2(152) -- 自定义项22
    ,def23 varchar2(152) -- 自定义项23
    ,def24 varchar2(152) -- 自定义项24
    ,def25 varchar2(152) -- 自定义项25
    ,def26 varchar2(152) -- 自定义项26
    ,def27 varchar2(152) -- 自定义项27
    ,def28 varchar2(152) -- 自定义项28
    ,def29 varchar2(152) -- 自定义项29
    ,def3 varchar2(152) -- 条线
    ,def30 varchar2(152) -- 自定义项30
    ,def31 varchar2(152) -- 自定义项31
    ,def32 varchar2(152) -- 自定义项32
    ,def33 varchar2(152) -- 自定义项33
    ,def34 varchar2(152) -- 自定义项34
    ,def35 varchar2(152) -- 自定义项35
    ,def36 varchar2(152) -- 自定义项36
    ,def37 varchar2(152) -- 自定义项37
    ,def38 varchar2(152) -- 自定义项38
    ,def39 varchar2(152) -- 自定义项39
    ,def4 varchar2(152) -- 自定义项4
    ,def40 varchar2(152) -- 自定义项40
    ,def41 varchar2(152) -- 自定义项41
    ,def42 varchar2(152) -- 自定义项42
    ,def43 varchar2(152) -- 自定义项43
    ,def44 varchar2(152) -- 自定义项44
    ,def45 varchar2(152) -- 自定义项45
    ,def46 varchar2(152) -- 自定义项46
    ,def47 varchar2(152) -- 自定义项47
    ,def48 varchar2(152) -- 自定义项48
    ,def49 varchar2(152) -- 自定义项49
    ,def5 varchar2(152) -- 自定义项5
    ,def50 varchar2(152) -- 自定义项50
    ,def51 varchar2(152) -- 自定义项51
    ,def52 varchar2(152) -- 自定义项52
    ,def53 varchar2(152) -- 自定义项53
    ,def54 varchar2(152) -- 自定义项54
    ,def55 varchar2(152) -- 自定义项55
    ,def56 varchar2(152) -- 自定义项56
    ,def57 varchar2(152) -- 自定义项57
    ,def58 varchar2(152) -- 自定义项58
    ,def59 varchar2(152) -- 自定义项59
    ,def6 varchar2(152) -- 自定义项6
    ,def60 varchar2(152) -- 自定义项60
    ,def61 varchar2(152) -- 自定义项61
    ,def62 varchar2(152) -- 自定义项62
    ,def63 varchar2(152) -- 自定义项63
    ,def64 varchar2(152) -- 自定义项64
    ,def65 varchar2(152) -- 自定义项65
    ,def66 varchar2(152) -- 自定义项66
    ,def67 varchar2(152) -- 自定义项67
    ,def68 varchar2(152) -- 自定义项68
    ,def69 varchar2(152) -- 自定义项69
    ,def7 varchar2(152) -- 自定义项7
    ,def70 varchar2(152) -- 自定义项70
    ,def71 varchar2(152) -- 自定义项71
    ,def72 varchar2(152) -- 自定义项72
    ,def73 varchar2(152) -- 自定义项73
    ,def74 varchar2(152) -- 自定义项74
    ,def75 varchar2(152) -- 自定义项75
    ,def76 varchar2(152) -- 自定义项76
    ,def77 varchar2(152) -- 自定义项77
    ,def78 varchar2(152) -- 自定义项78
    ,def79 varchar2(152) -- 自定义项79
    ,def8 varchar2(152) -- 自定义项8
    ,def80 varchar2(152) -- 自定义项80
    ,def9 varchar2(152) -- 自定义项9
    ,dr number(10,0) -- 删除标志
    ,pk_card varchar2(30) -- 扩展表主键
    ,ts varchar2(29) -- 时间戳
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
grant select on ${iol_schema}.iers_fa_cardsub to ${iml_schema};
grant select on ${iol_schema}.iers_fa_cardsub to ${icl_schema};
grant select on ${iol_schema}.iers_fa_cardsub to ${idl_schema};
grant select on ${iol_schema}.iers_fa_cardsub to ${iel_schema};

-- comment
comment on table ${iol_schema}.iers_fa_cardsub is 'fa_cardsub_扩展表';
comment on column ${iol_schema}.iers_fa_cardsub.def1 is '资产序号';
comment on column ${iol_schema}.iers_fa_cardsub.def10 is '序列号';
comment on column ${iol_schema}.iers_fa_cardsub.def11 is '自定义项11';
comment on column ${iol_schema}.iers_fa_cardsub.def12 is '自定义项12';
comment on column ${iol_schema}.iers_fa_cardsub.def13 is '自定义项13';
comment on column ${iol_schema}.iers_fa_cardsub.def14 is '自定义项14';
comment on column ${iol_schema}.iers_fa_cardsub.def15 is '自定义项15';
comment on column ${iol_schema}.iers_fa_cardsub.def16 is '自定义项16';
comment on column ${iol_schema}.iers_fa_cardsub.def17 is '自定义项17';
comment on column ${iol_schema}.iers_fa_cardsub.def18 is '自定义项18';
comment on column ${iol_schema}.iers_fa_cardsub.def19 is '评估余额';
comment on column ${iol_schema}.iers_fa_cardsub.def2 is '自定义项2';
comment on column ${iol_schema}.iers_fa_cardsub.def20 is '存放地点';
comment on column ${iol_schema}.iers_fa_cardsub.def21 is '自定义项21';
comment on column ${iol_schema}.iers_fa_cardsub.def22 is '自定义项22';
comment on column ${iol_schema}.iers_fa_cardsub.def23 is '自定义项23';
comment on column ${iol_schema}.iers_fa_cardsub.def24 is '自定义项24';
comment on column ${iol_schema}.iers_fa_cardsub.def25 is '自定义项25';
comment on column ${iol_schema}.iers_fa_cardsub.def26 is '自定义项26';
comment on column ${iol_schema}.iers_fa_cardsub.def27 is '自定义项27';
comment on column ${iol_schema}.iers_fa_cardsub.def28 is '自定义项28';
comment on column ${iol_schema}.iers_fa_cardsub.def29 is '自定义项29';
comment on column ${iol_schema}.iers_fa_cardsub.def3 is '条线';
comment on column ${iol_schema}.iers_fa_cardsub.def30 is '自定义项30';
comment on column ${iol_schema}.iers_fa_cardsub.def31 is '自定义项31';
comment on column ${iol_schema}.iers_fa_cardsub.def32 is '自定义项32';
comment on column ${iol_schema}.iers_fa_cardsub.def33 is '自定义项33';
comment on column ${iol_schema}.iers_fa_cardsub.def34 is '自定义项34';
comment on column ${iol_schema}.iers_fa_cardsub.def35 is '自定义项35';
comment on column ${iol_schema}.iers_fa_cardsub.def36 is '自定义项36';
comment on column ${iol_schema}.iers_fa_cardsub.def37 is '自定义项37';
comment on column ${iol_schema}.iers_fa_cardsub.def38 is '自定义项38';
comment on column ${iol_schema}.iers_fa_cardsub.def39 is '自定义项39';
comment on column ${iol_schema}.iers_fa_cardsub.def4 is '自定义项4';
comment on column ${iol_schema}.iers_fa_cardsub.def40 is '自定义项40';
comment on column ${iol_schema}.iers_fa_cardsub.def41 is '自定义项41';
comment on column ${iol_schema}.iers_fa_cardsub.def42 is '自定义项42';
comment on column ${iol_schema}.iers_fa_cardsub.def43 is '自定义项43';
comment on column ${iol_schema}.iers_fa_cardsub.def44 is '自定义项44';
comment on column ${iol_schema}.iers_fa_cardsub.def45 is '自定义项45';
comment on column ${iol_schema}.iers_fa_cardsub.def46 is '自定义项46';
comment on column ${iol_schema}.iers_fa_cardsub.def47 is '自定义项47';
comment on column ${iol_schema}.iers_fa_cardsub.def48 is '自定义项48';
comment on column ${iol_schema}.iers_fa_cardsub.def49 is '自定义项49';
comment on column ${iol_schema}.iers_fa_cardsub.def5 is '自定义项5';
comment on column ${iol_schema}.iers_fa_cardsub.def50 is '自定义项50';
comment on column ${iol_schema}.iers_fa_cardsub.def51 is '自定义项51';
comment on column ${iol_schema}.iers_fa_cardsub.def52 is '自定义项52';
comment on column ${iol_schema}.iers_fa_cardsub.def53 is '自定义项53';
comment on column ${iol_schema}.iers_fa_cardsub.def54 is '自定义项54';
comment on column ${iol_schema}.iers_fa_cardsub.def55 is '自定义项55';
comment on column ${iol_schema}.iers_fa_cardsub.def56 is '自定义项56';
comment on column ${iol_schema}.iers_fa_cardsub.def57 is '自定义项57';
comment on column ${iol_schema}.iers_fa_cardsub.def58 is '自定义项58';
comment on column ${iol_schema}.iers_fa_cardsub.def59 is '自定义项59';
comment on column ${iol_schema}.iers_fa_cardsub.def6 is '自定义项6';
comment on column ${iol_schema}.iers_fa_cardsub.def60 is '自定义项60';
comment on column ${iol_schema}.iers_fa_cardsub.def61 is '自定义项61';
comment on column ${iol_schema}.iers_fa_cardsub.def62 is '自定义项62';
comment on column ${iol_schema}.iers_fa_cardsub.def63 is '自定义项63';
comment on column ${iol_schema}.iers_fa_cardsub.def64 is '自定义项64';
comment on column ${iol_schema}.iers_fa_cardsub.def65 is '自定义项65';
comment on column ${iol_schema}.iers_fa_cardsub.def66 is '自定义项66';
comment on column ${iol_schema}.iers_fa_cardsub.def67 is '自定义项67';
comment on column ${iol_schema}.iers_fa_cardsub.def68 is '自定义项68';
comment on column ${iol_schema}.iers_fa_cardsub.def69 is '自定义项69';
comment on column ${iol_schema}.iers_fa_cardsub.def7 is '自定义项7';
comment on column ${iol_schema}.iers_fa_cardsub.def70 is '自定义项70';
comment on column ${iol_schema}.iers_fa_cardsub.def71 is '自定义项71';
comment on column ${iol_schema}.iers_fa_cardsub.def72 is '自定义项72';
comment on column ${iol_schema}.iers_fa_cardsub.def73 is '自定义项73';
comment on column ${iol_schema}.iers_fa_cardsub.def74 is '自定义项74';
comment on column ${iol_schema}.iers_fa_cardsub.def75 is '自定义项75';
comment on column ${iol_schema}.iers_fa_cardsub.def76 is '自定义项76';
comment on column ${iol_schema}.iers_fa_cardsub.def77 is '自定义项77';
comment on column ${iol_schema}.iers_fa_cardsub.def78 is '自定义项78';
comment on column ${iol_schema}.iers_fa_cardsub.def79 is '自定义项79';
comment on column ${iol_schema}.iers_fa_cardsub.def8 is '自定义项8';
comment on column ${iol_schema}.iers_fa_cardsub.def80 is '自定义项80';
comment on column ${iol_schema}.iers_fa_cardsub.def9 is '自定义项9';
comment on column ${iol_schema}.iers_fa_cardsub.dr is '删除标志';
comment on column ${iol_schema}.iers_fa_cardsub.pk_card is '扩展表主键';
comment on column ${iol_schema}.iers_fa_cardsub.ts is '时间戳';
comment on column ${iol_schema}.iers_fa_cardsub.start_dt is '开始时间';
comment on column ${iol_schema}.iers_fa_cardsub.end_dt is '结束时间';
comment on column ${iol_schema}.iers_fa_cardsub.id_mark is '增删标志';
comment on column ${iol_schema}.iers_fa_cardsub.etl_timestamp is 'ETL处理时间戳';
