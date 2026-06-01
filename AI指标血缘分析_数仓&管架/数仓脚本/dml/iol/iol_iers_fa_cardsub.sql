/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_fa_cardsub
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.iers_fa_cardsub_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_fa_cardsub
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fa_cardsub_op purge;
drop table ${iol_schema}.iers_fa_cardsub_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fa_cardsub_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_fa_cardsub where 0=1;

create table ${iol_schema}.iers_fa_cardsub_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_fa_cardsub where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fa_cardsub_cl(
            def1 -- 资产序号
            ,def10 -- 序列号
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 评估余额
            ,def2 -- 自定义项2
            ,def20 -- 存放地点
            ,def21 -- 自定义项21
            ,def22 -- 自定义项22
            ,def23 -- 自定义项23
            ,def24 -- 自定义项24
            ,def25 -- 自定义项25
            ,def26 -- 自定义项26
            ,def27 -- 自定义项27
            ,def28 -- 自定义项28
            ,def29 -- 自定义项29
            ,def3 -- 条线
            ,def30 -- 自定义项30
            ,def31 -- 自定义项31
            ,def32 -- 自定义项32
            ,def33 -- 自定义项33
            ,def34 -- 自定义项34
            ,def35 -- 自定义项35
            ,def36 -- 自定义项36
            ,def37 -- 自定义项37
            ,def38 -- 自定义项38
            ,def39 -- 自定义项39
            ,def4 -- 自定义项4
            ,def40 -- 自定义项40
            ,def41 -- 自定义项41
            ,def42 -- 自定义项42
            ,def43 -- 自定义项43
            ,def44 -- 自定义项44
            ,def45 -- 自定义项45
            ,def46 -- 自定义项46
            ,def47 -- 自定义项47
            ,def48 -- 自定义项48
            ,def49 -- 自定义项49
            ,def5 -- 自定义项5
            ,def50 -- 自定义项50
            ,def51 -- 自定义项51
            ,def52 -- 自定义项52
            ,def53 -- 自定义项53
            ,def54 -- 自定义项54
            ,def55 -- 自定义项55
            ,def56 -- 自定义项56
            ,def57 -- 自定义项57
            ,def58 -- 自定义项58
            ,def59 -- 自定义项59
            ,def6 -- 自定义项6
            ,def60 -- 自定义项60
            ,def61 -- 自定义项61
            ,def62 -- 自定义项62
            ,def63 -- 自定义项63
            ,def64 -- 自定义项64
            ,def65 -- 自定义项65
            ,def66 -- 自定义项66
            ,def67 -- 自定义项67
            ,def68 -- 自定义项68
            ,def69 -- 自定义项69
            ,def7 -- 自定义项7
            ,def70 -- 自定义项70
            ,def71 -- 自定义项71
            ,def72 -- 自定义项72
            ,def73 -- 自定义项73
            ,def74 -- 自定义项74
            ,def75 -- 自定义项75
            ,def76 -- 自定义项76
            ,def77 -- 自定义项77
            ,def78 -- 自定义项78
            ,def79 -- 自定义项79
            ,def8 -- 自定义项8
            ,def80 -- 自定义项80
            ,def9 -- 自定义项9
            ,dr -- 删除标志
            ,pk_card -- 扩展表主键
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fa_cardsub_op(
            def1 -- 资产序号
            ,def10 -- 序列号
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 评估余额
            ,def2 -- 自定义项2
            ,def20 -- 存放地点
            ,def21 -- 自定义项21
            ,def22 -- 自定义项22
            ,def23 -- 自定义项23
            ,def24 -- 自定义项24
            ,def25 -- 自定义项25
            ,def26 -- 自定义项26
            ,def27 -- 自定义项27
            ,def28 -- 自定义项28
            ,def29 -- 自定义项29
            ,def3 -- 条线
            ,def30 -- 自定义项30
            ,def31 -- 自定义项31
            ,def32 -- 自定义项32
            ,def33 -- 自定义项33
            ,def34 -- 自定义项34
            ,def35 -- 自定义项35
            ,def36 -- 自定义项36
            ,def37 -- 自定义项37
            ,def38 -- 自定义项38
            ,def39 -- 自定义项39
            ,def4 -- 自定义项4
            ,def40 -- 自定义项40
            ,def41 -- 自定义项41
            ,def42 -- 自定义项42
            ,def43 -- 自定义项43
            ,def44 -- 自定义项44
            ,def45 -- 自定义项45
            ,def46 -- 自定义项46
            ,def47 -- 自定义项47
            ,def48 -- 自定义项48
            ,def49 -- 自定义项49
            ,def5 -- 自定义项5
            ,def50 -- 自定义项50
            ,def51 -- 自定义项51
            ,def52 -- 自定义项52
            ,def53 -- 自定义项53
            ,def54 -- 自定义项54
            ,def55 -- 自定义项55
            ,def56 -- 自定义项56
            ,def57 -- 自定义项57
            ,def58 -- 自定义项58
            ,def59 -- 自定义项59
            ,def6 -- 自定义项6
            ,def60 -- 自定义项60
            ,def61 -- 自定义项61
            ,def62 -- 自定义项62
            ,def63 -- 自定义项63
            ,def64 -- 自定义项64
            ,def65 -- 自定义项65
            ,def66 -- 自定义项66
            ,def67 -- 自定义项67
            ,def68 -- 自定义项68
            ,def69 -- 自定义项69
            ,def7 -- 自定义项7
            ,def70 -- 自定义项70
            ,def71 -- 自定义项71
            ,def72 -- 自定义项72
            ,def73 -- 自定义项73
            ,def74 -- 自定义项74
            ,def75 -- 自定义项75
            ,def76 -- 自定义项76
            ,def77 -- 自定义项77
            ,def78 -- 自定义项78
            ,def79 -- 自定义项79
            ,def8 -- 自定义项8
            ,def80 -- 自定义项80
            ,def9 -- 自定义项9
            ,dr -- 删除标志
            ,pk_card -- 扩展表主键
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.def1, o.def1) as def1 -- 资产序号
    ,nvl(n.def10, o.def10) as def10 -- 序列号
    ,nvl(n.def11, o.def11) as def11 -- 自定义项11
    ,nvl(n.def12, o.def12) as def12 -- 自定义项12
    ,nvl(n.def13, o.def13) as def13 -- 自定义项13
    ,nvl(n.def14, o.def14) as def14 -- 自定义项14
    ,nvl(n.def15, o.def15) as def15 -- 自定义项15
    ,nvl(n.def16, o.def16) as def16 -- 自定义项16
    ,nvl(n.def17, o.def17) as def17 -- 自定义项17
    ,nvl(n.def18, o.def18) as def18 -- 自定义项18
    ,nvl(n.def19, o.def19) as def19 -- 评估余额
    ,nvl(n.def2, o.def2) as def2 -- 自定义项2
    ,nvl(n.def20, o.def20) as def20 -- 存放地点
    ,nvl(n.def21, o.def21) as def21 -- 自定义项21
    ,nvl(n.def22, o.def22) as def22 -- 自定义项22
    ,nvl(n.def23, o.def23) as def23 -- 自定义项23
    ,nvl(n.def24, o.def24) as def24 -- 自定义项24
    ,nvl(n.def25, o.def25) as def25 -- 自定义项25
    ,nvl(n.def26, o.def26) as def26 -- 自定义项26
    ,nvl(n.def27, o.def27) as def27 -- 自定义项27
    ,nvl(n.def28, o.def28) as def28 -- 自定义项28
    ,nvl(n.def29, o.def29) as def29 -- 自定义项29
    ,nvl(n.def3, o.def3) as def3 -- 条线
    ,nvl(n.def30, o.def30) as def30 -- 自定义项30
    ,nvl(n.def31, o.def31) as def31 -- 自定义项31
    ,nvl(n.def32, o.def32) as def32 -- 自定义项32
    ,nvl(n.def33, o.def33) as def33 -- 自定义项33
    ,nvl(n.def34, o.def34) as def34 -- 自定义项34
    ,nvl(n.def35, o.def35) as def35 -- 自定义项35
    ,nvl(n.def36, o.def36) as def36 -- 自定义项36
    ,nvl(n.def37, o.def37) as def37 -- 自定义项37
    ,nvl(n.def38, o.def38) as def38 -- 自定义项38
    ,nvl(n.def39, o.def39) as def39 -- 自定义项39
    ,nvl(n.def4, o.def4) as def4 -- 自定义项4
    ,nvl(n.def40, o.def40) as def40 -- 自定义项40
    ,nvl(n.def41, o.def41) as def41 -- 自定义项41
    ,nvl(n.def42, o.def42) as def42 -- 自定义项42
    ,nvl(n.def43, o.def43) as def43 -- 自定义项43
    ,nvl(n.def44, o.def44) as def44 -- 自定义项44
    ,nvl(n.def45, o.def45) as def45 -- 自定义项45
    ,nvl(n.def46, o.def46) as def46 -- 自定义项46
    ,nvl(n.def47, o.def47) as def47 -- 自定义项47
    ,nvl(n.def48, o.def48) as def48 -- 自定义项48
    ,nvl(n.def49, o.def49) as def49 -- 自定义项49
    ,nvl(n.def5, o.def5) as def5 -- 自定义项5
    ,nvl(n.def50, o.def50) as def50 -- 自定义项50
    ,nvl(n.def51, o.def51) as def51 -- 自定义项51
    ,nvl(n.def52, o.def52) as def52 -- 自定义项52
    ,nvl(n.def53, o.def53) as def53 -- 自定义项53
    ,nvl(n.def54, o.def54) as def54 -- 自定义项54
    ,nvl(n.def55, o.def55) as def55 -- 自定义项55
    ,nvl(n.def56, o.def56) as def56 -- 自定义项56
    ,nvl(n.def57, o.def57) as def57 -- 自定义项57
    ,nvl(n.def58, o.def58) as def58 -- 自定义项58
    ,nvl(n.def59, o.def59) as def59 -- 自定义项59
    ,nvl(n.def6, o.def6) as def6 -- 自定义项6
    ,nvl(n.def60, o.def60) as def60 -- 自定义项60
    ,nvl(n.def61, o.def61) as def61 -- 自定义项61
    ,nvl(n.def62, o.def62) as def62 -- 自定义项62
    ,nvl(n.def63, o.def63) as def63 -- 自定义项63
    ,nvl(n.def64, o.def64) as def64 -- 自定义项64
    ,nvl(n.def65, o.def65) as def65 -- 自定义项65
    ,nvl(n.def66, o.def66) as def66 -- 自定义项66
    ,nvl(n.def67, o.def67) as def67 -- 自定义项67
    ,nvl(n.def68, o.def68) as def68 -- 自定义项68
    ,nvl(n.def69, o.def69) as def69 -- 自定义项69
    ,nvl(n.def7, o.def7) as def7 -- 自定义项7
    ,nvl(n.def70, o.def70) as def70 -- 自定义项70
    ,nvl(n.def71, o.def71) as def71 -- 自定义项71
    ,nvl(n.def72, o.def72) as def72 -- 自定义项72
    ,nvl(n.def73, o.def73) as def73 -- 自定义项73
    ,nvl(n.def74, o.def74) as def74 -- 自定义项74
    ,nvl(n.def75, o.def75) as def75 -- 自定义项75
    ,nvl(n.def76, o.def76) as def76 -- 自定义项76
    ,nvl(n.def77, o.def77) as def77 -- 自定义项77
    ,nvl(n.def78, o.def78) as def78 -- 自定义项78
    ,nvl(n.def79, o.def79) as def79 -- 自定义项79
    ,nvl(n.def8, o.def8) as def8 -- 自定义项8
    ,nvl(n.def80, o.def80) as def80 -- 自定义项80
    ,nvl(n.def9, o.def9) as def9 -- 自定义项9
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.pk_card, o.pk_card) as pk_card -- 扩展表主键
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,case when
            n.pk_card is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_card is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_card is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_fa_cardsub_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_fa_cardsub where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_card = n.pk_card
where (
        o.pk_card is null
    )
    or (
        n.pk_card is null
    )
    or (
        o.def1 <> n.def1
        or o.def10 <> n.def10
        or o.def11 <> n.def11
        or o.def12 <> n.def12
        or o.def13 <> n.def13
        or o.def14 <> n.def14
        or o.def15 <> n.def15
        or o.def16 <> n.def16
        or o.def17 <> n.def17
        or o.def18 <> n.def18
        or o.def19 <> n.def19
        or o.def2 <> n.def2
        or o.def20 <> n.def20
        or o.def21 <> n.def21
        or o.def22 <> n.def22
        or o.def23 <> n.def23
        or o.def24 <> n.def24
        or o.def25 <> n.def25
        or o.def26 <> n.def26
        or o.def27 <> n.def27
        or o.def28 <> n.def28
        or o.def29 <> n.def29
        or o.def3 <> n.def3
        or o.def30 <> n.def30
        or o.def31 <> n.def31
        or o.def32 <> n.def32
        or o.def33 <> n.def33
        or o.def34 <> n.def34
        or o.def35 <> n.def35
        or o.def36 <> n.def36
        or o.def37 <> n.def37
        or o.def38 <> n.def38
        or o.def39 <> n.def39
        or o.def4 <> n.def4
        or o.def40 <> n.def40
        or o.def41 <> n.def41
        or o.def42 <> n.def42
        or o.def43 <> n.def43
        or o.def44 <> n.def44
        or o.def45 <> n.def45
        or o.def46 <> n.def46
        or o.def47 <> n.def47
        or o.def48 <> n.def48
        or o.def49 <> n.def49
        or o.def5 <> n.def5
        or o.def50 <> n.def50
        or o.def51 <> n.def51
        or o.def52 <> n.def52
        or o.def53 <> n.def53
        or o.def54 <> n.def54
        or o.def55 <> n.def55
        or o.def56 <> n.def56
        or o.def57 <> n.def57
        or o.def58 <> n.def58
        or o.def59 <> n.def59
        or o.def6 <> n.def6
        or o.def60 <> n.def60
        or o.def61 <> n.def61
        or o.def62 <> n.def62
        or o.def63 <> n.def63
        or o.def64 <> n.def64
        or o.def65 <> n.def65
        or o.def66 <> n.def66
        or o.def67 <> n.def67
        or o.def68 <> n.def68
        or o.def69 <> n.def69
        or o.def7 <> n.def7
        or o.def70 <> n.def70
        or o.def71 <> n.def71
        or o.def72 <> n.def72
        or o.def73 <> n.def73
        or o.def74 <> n.def74
        or o.def75 <> n.def75
        or o.def76 <> n.def76
        or o.def77 <> n.def77
        or o.def78 <> n.def78
        or o.def79 <> n.def79
        or o.def8 <> n.def8
        or o.def80 <> n.def80
        or o.def9 <> n.def9
        or o.dr <> n.dr
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fa_cardsub_cl(
            def1 -- 资产序号
            ,def10 -- 序列号
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 评估余额
            ,def2 -- 自定义项2
            ,def20 -- 存放地点
            ,def21 -- 自定义项21
            ,def22 -- 自定义项22
            ,def23 -- 自定义项23
            ,def24 -- 自定义项24
            ,def25 -- 自定义项25
            ,def26 -- 自定义项26
            ,def27 -- 自定义项27
            ,def28 -- 自定义项28
            ,def29 -- 自定义项29
            ,def3 -- 条线
            ,def30 -- 自定义项30
            ,def31 -- 自定义项31
            ,def32 -- 自定义项32
            ,def33 -- 自定义项33
            ,def34 -- 自定义项34
            ,def35 -- 自定义项35
            ,def36 -- 自定义项36
            ,def37 -- 自定义项37
            ,def38 -- 自定义项38
            ,def39 -- 自定义项39
            ,def4 -- 自定义项4
            ,def40 -- 自定义项40
            ,def41 -- 自定义项41
            ,def42 -- 自定义项42
            ,def43 -- 自定义项43
            ,def44 -- 自定义项44
            ,def45 -- 自定义项45
            ,def46 -- 自定义项46
            ,def47 -- 自定义项47
            ,def48 -- 自定义项48
            ,def49 -- 自定义项49
            ,def5 -- 自定义项5
            ,def50 -- 自定义项50
            ,def51 -- 自定义项51
            ,def52 -- 自定义项52
            ,def53 -- 自定义项53
            ,def54 -- 自定义项54
            ,def55 -- 自定义项55
            ,def56 -- 自定义项56
            ,def57 -- 自定义项57
            ,def58 -- 自定义项58
            ,def59 -- 自定义项59
            ,def6 -- 自定义项6
            ,def60 -- 自定义项60
            ,def61 -- 自定义项61
            ,def62 -- 自定义项62
            ,def63 -- 自定义项63
            ,def64 -- 自定义项64
            ,def65 -- 自定义项65
            ,def66 -- 自定义项66
            ,def67 -- 自定义项67
            ,def68 -- 自定义项68
            ,def69 -- 自定义项69
            ,def7 -- 自定义项7
            ,def70 -- 自定义项70
            ,def71 -- 自定义项71
            ,def72 -- 自定义项72
            ,def73 -- 自定义项73
            ,def74 -- 自定义项74
            ,def75 -- 自定义项75
            ,def76 -- 自定义项76
            ,def77 -- 自定义项77
            ,def78 -- 自定义项78
            ,def79 -- 自定义项79
            ,def8 -- 自定义项8
            ,def80 -- 自定义项80
            ,def9 -- 自定义项9
            ,dr -- 删除标志
            ,pk_card -- 扩展表主键
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fa_cardsub_op(
            def1 -- 资产序号
            ,def10 -- 序列号
            ,def11 -- 自定义项11
            ,def12 -- 自定义项12
            ,def13 -- 自定义项13
            ,def14 -- 自定义项14
            ,def15 -- 自定义项15
            ,def16 -- 自定义项16
            ,def17 -- 自定义项17
            ,def18 -- 自定义项18
            ,def19 -- 评估余额
            ,def2 -- 自定义项2
            ,def20 -- 存放地点
            ,def21 -- 自定义项21
            ,def22 -- 自定义项22
            ,def23 -- 自定义项23
            ,def24 -- 自定义项24
            ,def25 -- 自定义项25
            ,def26 -- 自定义项26
            ,def27 -- 自定义项27
            ,def28 -- 自定义项28
            ,def29 -- 自定义项29
            ,def3 -- 条线
            ,def30 -- 自定义项30
            ,def31 -- 自定义项31
            ,def32 -- 自定义项32
            ,def33 -- 自定义项33
            ,def34 -- 自定义项34
            ,def35 -- 自定义项35
            ,def36 -- 自定义项36
            ,def37 -- 自定义项37
            ,def38 -- 自定义项38
            ,def39 -- 自定义项39
            ,def4 -- 自定义项4
            ,def40 -- 自定义项40
            ,def41 -- 自定义项41
            ,def42 -- 自定义项42
            ,def43 -- 自定义项43
            ,def44 -- 自定义项44
            ,def45 -- 自定义项45
            ,def46 -- 自定义项46
            ,def47 -- 自定义项47
            ,def48 -- 自定义项48
            ,def49 -- 自定义项49
            ,def5 -- 自定义项5
            ,def50 -- 自定义项50
            ,def51 -- 自定义项51
            ,def52 -- 自定义项52
            ,def53 -- 自定义项53
            ,def54 -- 自定义项54
            ,def55 -- 自定义项55
            ,def56 -- 自定义项56
            ,def57 -- 自定义项57
            ,def58 -- 自定义项58
            ,def59 -- 自定义项59
            ,def6 -- 自定义项6
            ,def60 -- 自定义项60
            ,def61 -- 自定义项61
            ,def62 -- 自定义项62
            ,def63 -- 自定义项63
            ,def64 -- 自定义项64
            ,def65 -- 自定义项65
            ,def66 -- 自定义项66
            ,def67 -- 自定义项67
            ,def68 -- 自定义项68
            ,def69 -- 自定义项69
            ,def7 -- 自定义项7
            ,def70 -- 自定义项70
            ,def71 -- 自定义项71
            ,def72 -- 自定义项72
            ,def73 -- 自定义项73
            ,def74 -- 自定义项74
            ,def75 -- 自定义项75
            ,def76 -- 自定义项76
            ,def77 -- 自定义项77
            ,def78 -- 自定义项78
            ,def79 -- 自定义项79
            ,def8 -- 自定义项8
            ,def80 -- 自定义项80
            ,def9 -- 自定义项9
            ,dr -- 删除标志
            ,pk_card -- 扩展表主键
            ,ts -- 时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.def1 -- 资产序号
    ,o.def10 -- 序列号
    ,o.def11 -- 自定义项11
    ,o.def12 -- 自定义项12
    ,o.def13 -- 自定义项13
    ,o.def14 -- 自定义项14
    ,o.def15 -- 自定义项15
    ,o.def16 -- 自定义项16
    ,o.def17 -- 自定义项17
    ,o.def18 -- 自定义项18
    ,o.def19 -- 评估余额
    ,o.def2 -- 自定义项2
    ,o.def20 -- 存放地点
    ,o.def21 -- 自定义项21
    ,o.def22 -- 自定义项22
    ,o.def23 -- 自定义项23
    ,o.def24 -- 自定义项24
    ,o.def25 -- 自定义项25
    ,o.def26 -- 自定义项26
    ,o.def27 -- 自定义项27
    ,o.def28 -- 自定义项28
    ,o.def29 -- 自定义项29
    ,o.def3 -- 条线
    ,o.def30 -- 自定义项30
    ,o.def31 -- 自定义项31
    ,o.def32 -- 自定义项32
    ,o.def33 -- 自定义项33
    ,o.def34 -- 自定义项34
    ,o.def35 -- 自定义项35
    ,o.def36 -- 自定义项36
    ,o.def37 -- 自定义项37
    ,o.def38 -- 自定义项38
    ,o.def39 -- 自定义项39
    ,o.def4 -- 自定义项4
    ,o.def40 -- 自定义项40
    ,o.def41 -- 自定义项41
    ,o.def42 -- 自定义项42
    ,o.def43 -- 自定义项43
    ,o.def44 -- 自定义项44
    ,o.def45 -- 自定义项45
    ,o.def46 -- 自定义项46
    ,o.def47 -- 自定义项47
    ,o.def48 -- 自定义项48
    ,o.def49 -- 自定义项49
    ,o.def5 -- 自定义项5
    ,o.def50 -- 自定义项50
    ,o.def51 -- 自定义项51
    ,o.def52 -- 自定义项52
    ,o.def53 -- 自定义项53
    ,o.def54 -- 自定义项54
    ,o.def55 -- 自定义项55
    ,o.def56 -- 自定义项56
    ,o.def57 -- 自定义项57
    ,o.def58 -- 自定义项58
    ,o.def59 -- 自定义项59
    ,o.def6 -- 自定义项6
    ,o.def60 -- 自定义项60
    ,o.def61 -- 自定义项61
    ,o.def62 -- 自定义项62
    ,o.def63 -- 自定义项63
    ,o.def64 -- 自定义项64
    ,o.def65 -- 自定义项65
    ,o.def66 -- 自定义项66
    ,o.def67 -- 自定义项67
    ,o.def68 -- 自定义项68
    ,o.def69 -- 自定义项69
    ,o.def7 -- 自定义项7
    ,o.def70 -- 自定义项70
    ,o.def71 -- 自定义项71
    ,o.def72 -- 自定义项72
    ,o.def73 -- 自定义项73
    ,o.def74 -- 自定义项74
    ,o.def75 -- 自定义项75
    ,o.def76 -- 自定义项76
    ,o.def77 -- 自定义项77
    ,o.def78 -- 自定义项78
    ,o.def79 -- 自定义项79
    ,o.def8 -- 自定义项8
    ,o.def80 -- 自定义项80
    ,o.def9 -- 自定义项9
    ,o.dr -- 删除标志
    ,o.pk_card -- 扩展表主键
    ,o.ts -- 时间戳
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.iers_fa_cardsub_bk o
    left join ${iol_schema}.iers_fa_cardsub_op n
        on
            o.pk_card = n.pk_card
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_fa_cardsub_cl d
        on
            o.pk_card = d.pk_card
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_fa_cardsub;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_fa_cardsub') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_fa_cardsub drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_fa_cardsub add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_fa_cardsub exchange partition p_${batch_date} with table ${iol_schema}.iers_fa_cardsub_cl;
alter table ${iol_schema}.iers_fa_cardsub exchange partition p_20991231 with table ${iol_schema}.iers_fa_cardsub_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_fa_cardsub to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fa_cardsub_op purge;
drop table ${iol_schema}.iers_fa_cardsub_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_fa_cardsub_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_fa_cardsub',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
