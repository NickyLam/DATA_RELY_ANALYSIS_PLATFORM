/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_report_ds_loan_receipt_additional_info_day
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
create table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_op purge;
drop table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day where 0=1;

create table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_cl(
            partitiondate -- 批量日期
            ,logicalcardno -- 逻辑卡号
            ,loanreceiptnbr -- 借据号
            ,loanusage -- 贷款用途
            ,customertype -- 借款人身份
            ,loanprocessflag -- 借据标识
            ,assetplanno -- 资产计划号
            ,lastbankgroupid -- 初始参贷方案
            ,refnbr -- 交易参考号
            ,integererestrate -- 实际执行的年化利率（360天）
            ,lpr -- 当期lpr值
            ,lprdate -- lpr公布日期
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,reserve7 -- 备用字段7
            ,loantype -- 还款方式
            ,reserve9 -- 被操作交易参考号
            ,reserve10 -- 操作时间
            ,identifytype -- 客户身份
            ,remainprinamtob -- 归属于合作机构的本金余额
            ,reserve13 -- 备用字段13
            ,reserve14 -- 客户收款银行名称（仅有收款行为出资行时有值）
            ,reserve15 -- 客户收款银行行号（仅有收款行为出资行时有值）
            ,reserve16 -- 客户收款账号（仅有收款行为出资行时有值）
            ,reserve17 -- 借款用途
            ,reserve18 -- 客户号
            ,reserve19 -- 借款合同名称
            ,reserve20 -- 借据起始日期
            ,reserve21 -- 借据原始到期日
            ,reserve22 -- 借据结清日期
            ,reserve23 -- 备用字段23
            ,reserve24 -- 备用字段24
            ,reserve25 -- 备用字段25
            ,reserve26 -- 备用字段26
            ,reserve27 -- 备用字段27
            ,reserve28 -- 备用字段28
            ,reserve29 -- 备用字段29
            ,reserve30 -- 备用字段30
            ,reserve31 -- 备用字段31
            ,reserve32 -- 备用字段32
            ,reserve33 -- 备用字段33
            ,reserve34 -- 备用字段34
            ,reserve35 -- 备用字段35
            ,reserve36 -- 备用字段36
            ,reserve37 -- 备用字段37
            ,reserve38 -- 备用字段38
            ,reserve39 -- 备用字段39
            ,reserve40 -- 备用字段40
            ,reserve41 -- 备用字段41
            ,reserve42 -- 备用字段42
            ,reserve43 -- 备用字段43
            ,reserve44 -- 备用字段44
            ,reserve45 -- 备用字段45
            ,reserve46 -- 备用字段46
            ,reserve47 -- 备用字段47
            ,reserve48 -- 备用字段48
            ,reserve49 -- 备用字段49
            ,reserve50 -- 备用字段50
            ,reserve51 -- 备用字段51
            ,reserve52 -- 备用字段52
            ,reserve53 -- 备用字段53
            ,reserve54 -- 备用字段54
            ,reserve55 -- 备用字段55
            ,reserve56 -- 备用字段56
            ,reserve57 -- 备用字段57
            ,reserve58 -- 备用字段58
            ,reserve59 -- 备用字段59
            ,reserve60 -- 备用字段60
            ,reserve61 -- 备用字段61
            ,reserve62 -- 备用字段62
            ,reserve63 -- 备用字段63
            ,reserve64 -- 备用字段64
            ,reserve65 -- 备用字段65
            ,reserve66 -- 备用字段66
            ,reserve67 -- 备用字段67
            ,reserve68 -- 备用字段68
            ,reserve69 -- 备用字段69
            ,reserve70 -- 备用字段70
            ,reserve71 -- 备用字段71
            ,reserve72 -- 备用字段72
            ,reserve73 -- 备用字段73
            ,reserve74 -- 备用字段74
            ,reserve75 -- 备用字段75
            ,reserve76 -- 备用字段76
            ,reserve77 -- 备用字段77
            ,reserve78 -- 备用字段78
            ,reserve79 -- 备用字段79
            ,reserve80 -- 备用字段80
            ,reserve81 -- 备用字段81
            ,reserve82 -- 备用字段82
            ,reserve83 -- 备用字段83
            ,reserve84 -- 备用字段84
            ,reserve85 -- 备用字段85
            ,reserve86 -- 备用字段86
            ,reserve87 -- 备用字段87
            ,reserve88 -- 备用字段88
            ,reserve89 -- 备用字段89
            ,reserve90 -- 备用字段90
            ,reserve91 -- 备用字段91
            ,reserve92 -- 备用字段92
            ,reserve93 -- 备用字段93
            ,reserve94 -- 备用字段94
            ,reserve95 -- 备用字段95
            ,reserve96 -- 备用字段96
            ,reserve97 -- 备用字段97
            ,reserve98 -- 备用字段98
            ,reserve99 -- 备用字段99
            ,reserve100 -- 备用字段100
            ,reserve101 -- 备用字段101
            ,reserve102 -- 备用字段102
            ,reserve103 -- 备用字段103
            ,reserve104 -- 备用字段104
            ,reserve105 -- 备用字段105
            ,reserve106 -- 备用字段106
            ,reserve107 -- 备用字段107
            ,reserve108 -- 备用字段108
            ,reserve109 -- 备用字段109
            ,reserve110 -- 备用字段110
            ,reserve111 -- 备用字段111
            ,reserve112 -- 备用字段112
            ,reserve113 -- 备用字段113
            ,reserve114 -- 备用字段114
            ,reserve115 -- 备用字段115
            ,reserve116 -- 备用字段116
            ,reserve117 -- 备用字段117
            ,reserve118 -- 备用字段118
            ,reserve119 -- 备用字段119
            ,reserve120 -- 备用字段120
            ,reserve121 -- 备用字段121
            ,reserve122 -- 备用字段122
            ,reserve123 -- 备用字段123
            ,reserve124 -- 备用字段124
            ,reserve125 -- 备用字段125
            ,reserve126 -- 备用字段126
            ,reserve127 -- 备用字段127
            ,reserve128 -- 备用字段128
            ,reserve129 -- 备用字段129
            ,reserve130 -- 备用字段130
            ,reserve131 -- 备用字段131
            ,reserve132 -- 备用字段132
            ,reserve133 -- 备用字段133
            ,reserve134 -- 备用字段134
            ,reserve135 -- 备用字段135
            ,reserve136 -- 备用字段136
            ,reserve137 -- 备用字段137
            ,reserve138 -- 备用字段138
            ,reserve139 -- 备用字段139
            ,reserve140 -- 备用字段140
            ,reserve141 -- 备用字段141
            ,reserve142 -- 备用字段142
            ,reserve143 -- 备用字段143
            ,reserve144 -- 备用字段144
            ,reserve145 -- 备用字段145
            ,reserve146 -- 备用字段146
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_op(
            partitiondate -- 批量日期
            ,logicalcardno -- 逻辑卡号
            ,loanreceiptnbr -- 借据号
            ,loanusage -- 贷款用途
            ,customertype -- 借款人身份
            ,loanprocessflag -- 借据标识
            ,assetplanno -- 资产计划号
            ,lastbankgroupid -- 初始参贷方案
            ,refnbr -- 交易参考号
            ,integererestrate -- 实际执行的年化利率（360天）
            ,lpr -- 当期lpr值
            ,lprdate -- lpr公布日期
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,reserve7 -- 备用字段7
            ,loantype -- 还款方式
            ,reserve9 -- 被操作交易参考号
            ,reserve10 -- 操作时间
            ,identifytype -- 客户身份
            ,remainprinamtob -- 归属于合作机构的本金余额
            ,reserve13 -- 备用字段13
            ,reserve14 -- 客户收款银行名称（仅有收款行为出资行时有值）
            ,reserve15 -- 客户收款银行行号（仅有收款行为出资行时有值）
            ,reserve16 -- 客户收款账号（仅有收款行为出资行时有值）
            ,reserve17 -- 借款用途
            ,reserve18 -- 客户号
            ,reserve19 -- 借款合同名称
            ,reserve20 -- 借据起始日期
            ,reserve21 -- 借据原始到期日
            ,reserve22 -- 借据结清日期
            ,reserve23 -- 备用字段23
            ,reserve24 -- 备用字段24
            ,reserve25 -- 备用字段25
            ,reserve26 -- 备用字段26
            ,reserve27 -- 备用字段27
            ,reserve28 -- 备用字段28
            ,reserve29 -- 备用字段29
            ,reserve30 -- 备用字段30
            ,reserve31 -- 备用字段31
            ,reserve32 -- 备用字段32
            ,reserve33 -- 备用字段33
            ,reserve34 -- 备用字段34
            ,reserve35 -- 备用字段35
            ,reserve36 -- 备用字段36
            ,reserve37 -- 备用字段37
            ,reserve38 -- 备用字段38
            ,reserve39 -- 备用字段39
            ,reserve40 -- 备用字段40
            ,reserve41 -- 备用字段41
            ,reserve42 -- 备用字段42
            ,reserve43 -- 备用字段43
            ,reserve44 -- 备用字段44
            ,reserve45 -- 备用字段45
            ,reserve46 -- 备用字段46
            ,reserve47 -- 备用字段47
            ,reserve48 -- 备用字段48
            ,reserve49 -- 备用字段49
            ,reserve50 -- 备用字段50
            ,reserve51 -- 备用字段51
            ,reserve52 -- 备用字段52
            ,reserve53 -- 备用字段53
            ,reserve54 -- 备用字段54
            ,reserve55 -- 备用字段55
            ,reserve56 -- 备用字段56
            ,reserve57 -- 备用字段57
            ,reserve58 -- 备用字段58
            ,reserve59 -- 备用字段59
            ,reserve60 -- 备用字段60
            ,reserve61 -- 备用字段61
            ,reserve62 -- 备用字段62
            ,reserve63 -- 备用字段63
            ,reserve64 -- 备用字段64
            ,reserve65 -- 备用字段65
            ,reserve66 -- 备用字段66
            ,reserve67 -- 备用字段67
            ,reserve68 -- 备用字段68
            ,reserve69 -- 备用字段69
            ,reserve70 -- 备用字段70
            ,reserve71 -- 备用字段71
            ,reserve72 -- 备用字段72
            ,reserve73 -- 备用字段73
            ,reserve74 -- 备用字段74
            ,reserve75 -- 备用字段75
            ,reserve76 -- 备用字段76
            ,reserve77 -- 备用字段77
            ,reserve78 -- 备用字段78
            ,reserve79 -- 备用字段79
            ,reserve80 -- 备用字段80
            ,reserve81 -- 备用字段81
            ,reserve82 -- 备用字段82
            ,reserve83 -- 备用字段83
            ,reserve84 -- 备用字段84
            ,reserve85 -- 备用字段85
            ,reserve86 -- 备用字段86
            ,reserve87 -- 备用字段87
            ,reserve88 -- 备用字段88
            ,reserve89 -- 备用字段89
            ,reserve90 -- 备用字段90
            ,reserve91 -- 备用字段91
            ,reserve92 -- 备用字段92
            ,reserve93 -- 备用字段93
            ,reserve94 -- 备用字段94
            ,reserve95 -- 备用字段95
            ,reserve96 -- 备用字段96
            ,reserve97 -- 备用字段97
            ,reserve98 -- 备用字段98
            ,reserve99 -- 备用字段99
            ,reserve100 -- 备用字段100
            ,reserve101 -- 备用字段101
            ,reserve102 -- 备用字段102
            ,reserve103 -- 备用字段103
            ,reserve104 -- 备用字段104
            ,reserve105 -- 备用字段105
            ,reserve106 -- 备用字段106
            ,reserve107 -- 备用字段107
            ,reserve108 -- 备用字段108
            ,reserve109 -- 备用字段109
            ,reserve110 -- 备用字段110
            ,reserve111 -- 备用字段111
            ,reserve112 -- 备用字段112
            ,reserve113 -- 备用字段113
            ,reserve114 -- 备用字段114
            ,reserve115 -- 备用字段115
            ,reserve116 -- 备用字段116
            ,reserve117 -- 备用字段117
            ,reserve118 -- 备用字段118
            ,reserve119 -- 备用字段119
            ,reserve120 -- 备用字段120
            ,reserve121 -- 备用字段121
            ,reserve122 -- 备用字段122
            ,reserve123 -- 备用字段123
            ,reserve124 -- 备用字段124
            ,reserve125 -- 备用字段125
            ,reserve126 -- 备用字段126
            ,reserve127 -- 备用字段127
            ,reserve128 -- 备用字段128
            ,reserve129 -- 备用字段129
            ,reserve130 -- 备用字段130
            ,reserve131 -- 备用字段131
            ,reserve132 -- 备用字段132
            ,reserve133 -- 备用字段133
            ,reserve134 -- 备用字段134
            ,reserve135 -- 备用字段135
            ,reserve136 -- 备用字段136
            ,reserve137 -- 备用字段137
            ,reserve138 -- 备用字段138
            ,reserve139 -- 备用字段139
            ,reserve140 -- 备用字段140
            ,reserve141 -- 备用字段141
            ,reserve142 -- 备用字段142
            ,reserve143 -- 备用字段143
            ,reserve144 -- 备用字段144
            ,reserve145 -- 备用字段145
            ,reserve146 -- 备用字段146
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.partitiondate, o.partitiondate) as partitiondate -- 批量日期
    ,nvl(n.logicalcardno, o.logicalcardno) as logicalcardno -- 逻辑卡号
    ,nvl(n.loanreceiptnbr, o.loanreceiptnbr) as loanreceiptnbr -- 借据号
    ,nvl(n.loanusage, o.loanusage) as loanusage -- 贷款用途
    ,nvl(n.customertype, o.customertype) as customertype -- 借款人身份
    ,nvl(n.loanprocessflag, o.loanprocessflag) as loanprocessflag -- 借据标识
    ,nvl(n.assetplanno, o.assetplanno) as assetplanno -- 资产计划号
    ,nvl(n.lastbankgroupid, o.lastbankgroupid) as lastbankgroupid -- 初始参贷方案
    ,nvl(n.refnbr, o.refnbr) as refnbr -- 交易参考号
    ,nvl(n.integererestrate, o.integererestrate) as integererestrate -- 实际执行的年化利率（360天）
    ,nvl(n.lpr, o.lpr) as lpr -- 当期lpr值
    ,nvl(n.lprdate, o.lprdate) as lprdate -- lpr公布日期
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备用字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备用字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 备用字段3
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 备用字段4
    ,nvl(n.reserve5, o.reserve5) as reserve5 -- 备用字段5
    ,nvl(n.reserve6, o.reserve6) as reserve6 -- 备用字段6
    ,nvl(n.reserve7, o.reserve7) as reserve7 -- 备用字段7
    ,nvl(n.loantype, o.loantype) as loantype -- 还款方式
    ,nvl(n.reserve9, o.reserve9) as reserve9 -- 被操作交易参考号
    ,nvl(n.reserve10, o.reserve10) as reserve10 -- 操作时间
    ,nvl(n.identifytype, o.identifytype) as identifytype -- 客户身份
    ,nvl(n.remainprinamtob, o.remainprinamtob) as remainprinamtob -- 归属于合作机构的本金余额
    ,nvl(n.reserve13, o.reserve13) as reserve13 -- 备用字段13
    ,nvl(n.reserve14, o.reserve14) as reserve14 -- 客户收款银行名称（仅有收款行为出资行时有值）
    ,nvl(n.reserve15, o.reserve15) as reserve15 -- 客户收款银行行号（仅有收款行为出资行时有值）
    ,nvl(n.reserve16, o.reserve16) as reserve16 -- 客户收款账号（仅有收款行为出资行时有值）
    ,nvl(n.reserve17, o.reserve17) as reserve17 -- 借款用途
    ,nvl(n.reserve18, o.reserve18) as reserve18 -- 客户号
    ,nvl(n.reserve19, o.reserve19) as reserve19 -- 借款合同名称
    ,nvl(n.reserve20, o.reserve20) as reserve20 -- 借据起始日期
    ,nvl(n.reserve21, o.reserve21) as reserve21 -- 借据原始到期日
    ,nvl(n.reserve22, o.reserve22) as reserve22 -- 借据结清日期
    ,nvl(n.reserve23, o.reserve23) as reserve23 -- 备用字段23
    ,nvl(n.reserve24, o.reserve24) as reserve24 -- 备用字段24
    ,nvl(n.reserve25, o.reserve25) as reserve25 -- 备用字段25
    ,nvl(n.reserve26, o.reserve26) as reserve26 -- 备用字段26
    ,nvl(n.reserve27, o.reserve27) as reserve27 -- 备用字段27
    ,nvl(n.reserve28, o.reserve28) as reserve28 -- 备用字段28
    ,nvl(n.reserve29, o.reserve29) as reserve29 -- 备用字段29
    ,nvl(n.reserve30, o.reserve30) as reserve30 -- 备用字段30
    ,nvl(n.reserve31, o.reserve31) as reserve31 -- 备用字段31
    ,nvl(n.reserve32, o.reserve32) as reserve32 -- 备用字段32
    ,nvl(n.reserve33, o.reserve33) as reserve33 -- 备用字段33
    ,nvl(n.reserve34, o.reserve34) as reserve34 -- 备用字段34
    ,nvl(n.reserve35, o.reserve35) as reserve35 -- 备用字段35
    ,nvl(n.reserve36, o.reserve36) as reserve36 -- 备用字段36
    ,nvl(n.reserve37, o.reserve37) as reserve37 -- 备用字段37
    ,nvl(n.reserve38, o.reserve38) as reserve38 -- 备用字段38
    ,nvl(n.reserve39, o.reserve39) as reserve39 -- 备用字段39
    ,nvl(n.reserve40, o.reserve40) as reserve40 -- 备用字段40
    ,nvl(n.reserve41, o.reserve41) as reserve41 -- 备用字段41
    ,nvl(n.reserve42, o.reserve42) as reserve42 -- 备用字段42
    ,nvl(n.reserve43, o.reserve43) as reserve43 -- 备用字段43
    ,nvl(n.reserve44, o.reserve44) as reserve44 -- 备用字段44
    ,nvl(n.reserve45, o.reserve45) as reserve45 -- 备用字段45
    ,nvl(n.reserve46, o.reserve46) as reserve46 -- 备用字段46
    ,nvl(n.reserve47, o.reserve47) as reserve47 -- 备用字段47
    ,nvl(n.reserve48, o.reserve48) as reserve48 -- 备用字段48
    ,nvl(n.reserve49, o.reserve49) as reserve49 -- 备用字段49
    ,nvl(n.reserve50, o.reserve50) as reserve50 -- 备用字段50
    ,nvl(n.reserve51, o.reserve51) as reserve51 -- 备用字段51
    ,nvl(n.reserve52, o.reserve52) as reserve52 -- 备用字段52
    ,nvl(n.reserve53, o.reserve53) as reserve53 -- 备用字段53
    ,nvl(n.reserve54, o.reserve54) as reserve54 -- 备用字段54
    ,nvl(n.reserve55, o.reserve55) as reserve55 -- 备用字段55
    ,nvl(n.reserve56, o.reserve56) as reserve56 -- 备用字段56
    ,nvl(n.reserve57, o.reserve57) as reserve57 -- 备用字段57
    ,nvl(n.reserve58, o.reserve58) as reserve58 -- 备用字段58
    ,nvl(n.reserve59, o.reserve59) as reserve59 -- 备用字段59
    ,nvl(n.reserve60, o.reserve60) as reserve60 -- 备用字段60
    ,nvl(n.reserve61, o.reserve61) as reserve61 -- 备用字段61
    ,nvl(n.reserve62, o.reserve62) as reserve62 -- 备用字段62
    ,nvl(n.reserve63, o.reserve63) as reserve63 -- 备用字段63
    ,nvl(n.reserve64, o.reserve64) as reserve64 -- 备用字段64
    ,nvl(n.reserve65, o.reserve65) as reserve65 -- 备用字段65
    ,nvl(n.reserve66, o.reserve66) as reserve66 -- 备用字段66
    ,nvl(n.reserve67, o.reserve67) as reserve67 -- 备用字段67
    ,nvl(n.reserve68, o.reserve68) as reserve68 -- 备用字段68
    ,nvl(n.reserve69, o.reserve69) as reserve69 -- 备用字段69
    ,nvl(n.reserve70, o.reserve70) as reserve70 -- 备用字段70
    ,nvl(n.reserve71, o.reserve71) as reserve71 -- 备用字段71
    ,nvl(n.reserve72, o.reserve72) as reserve72 -- 备用字段72
    ,nvl(n.reserve73, o.reserve73) as reserve73 -- 备用字段73
    ,nvl(n.reserve74, o.reserve74) as reserve74 -- 备用字段74
    ,nvl(n.reserve75, o.reserve75) as reserve75 -- 备用字段75
    ,nvl(n.reserve76, o.reserve76) as reserve76 -- 备用字段76
    ,nvl(n.reserve77, o.reserve77) as reserve77 -- 备用字段77
    ,nvl(n.reserve78, o.reserve78) as reserve78 -- 备用字段78
    ,nvl(n.reserve79, o.reserve79) as reserve79 -- 备用字段79
    ,nvl(n.reserve80, o.reserve80) as reserve80 -- 备用字段80
    ,nvl(n.reserve81, o.reserve81) as reserve81 -- 备用字段81
    ,nvl(n.reserve82, o.reserve82) as reserve82 -- 备用字段82
    ,nvl(n.reserve83, o.reserve83) as reserve83 -- 备用字段83
    ,nvl(n.reserve84, o.reserve84) as reserve84 -- 备用字段84
    ,nvl(n.reserve85, o.reserve85) as reserve85 -- 备用字段85
    ,nvl(n.reserve86, o.reserve86) as reserve86 -- 备用字段86
    ,nvl(n.reserve87, o.reserve87) as reserve87 -- 备用字段87
    ,nvl(n.reserve88, o.reserve88) as reserve88 -- 备用字段88
    ,nvl(n.reserve89, o.reserve89) as reserve89 -- 备用字段89
    ,nvl(n.reserve90, o.reserve90) as reserve90 -- 备用字段90
    ,nvl(n.reserve91, o.reserve91) as reserve91 -- 备用字段91
    ,nvl(n.reserve92, o.reserve92) as reserve92 -- 备用字段92
    ,nvl(n.reserve93, o.reserve93) as reserve93 -- 备用字段93
    ,nvl(n.reserve94, o.reserve94) as reserve94 -- 备用字段94
    ,nvl(n.reserve95, o.reserve95) as reserve95 -- 备用字段95
    ,nvl(n.reserve96, o.reserve96) as reserve96 -- 备用字段96
    ,nvl(n.reserve97, o.reserve97) as reserve97 -- 备用字段97
    ,nvl(n.reserve98, o.reserve98) as reserve98 -- 备用字段98
    ,nvl(n.reserve99, o.reserve99) as reserve99 -- 备用字段99
    ,nvl(n.reserve100, o.reserve100) as reserve100 -- 备用字段100
    ,nvl(n.reserve101, o.reserve101) as reserve101 -- 备用字段101
    ,nvl(n.reserve102, o.reserve102) as reserve102 -- 备用字段102
    ,nvl(n.reserve103, o.reserve103) as reserve103 -- 备用字段103
    ,nvl(n.reserve104, o.reserve104) as reserve104 -- 备用字段104
    ,nvl(n.reserve105, o.reserve105) as reserve105 -- 备用字段105
    ,nvl(n.reserve106, o.reserve106) as reserve106 -- 备用字段106
    ,nvl(n.reserve107, o.reserve107) as reserve107 -- 备用字段107
    ,nvl(n.reserve108, o.reserve108) as reserve108 -- 备用字段108
    ,nvl(n.reserve109, o.reserve109) as reserve109 -- 备用字段109
    ,nvl(n.reserve110, o.reserve110) as reserve110 -- 备用字段110
    ,nvl(n.reserve111, o.reserve111) as reserve111 -- 备用字段111
    ,nvl(n.reserve112, o.reserve112) as reserve112 -- 备用字段112
    ,nvl(n.reserve113, o.reserve113) as reserve113 -- 备用字段113
    ,nvl(n.reserve114, o.reserve114) as reserve114 -- 备用字段114
    ,nvl(n.reserve115, o.reserve115) as reserve115 -- 备用字段115
    ,nvl(n.reserve116, o.reserve116) as reserve116 -- 备用字段116
    ,nvl(n.reserve117, o.reserve117) as reserve117 -- 备用字段117
    ,nvl(n.reserve118, o.reserve118) as reserve118 -- 备用字段118
    ,nvl(n.reserve119, o.reserve119) as reserve119 -- 备用字段119
    ,nvl(n.reserve120, o.reserve120) as reserve120 -- 备用字段120
    ,nvl(n.reserve121, o.reserve121) as reserve121 -- 备用字段121
    ,nvl(n.reserve122, o.reserve122) as reserve122 -- 备用字段122
    ,nvl(n.reserve123, o.reserve123) as reserve123 -- 备用字段123
    ,nvl(n.reserve124, o.reserve124) as reserve124 -- 备用字段124
    ,nvl(n.reserve125, o.reserve125) as reserve125 -- 备用字段125
    ,nvl(n.reserve126, o.reserve126) as reserve126 -- 备用字段126
    ,nvl(n.reserve127, o.reserve127) as reserve127 -- 备用字段127
    ,nvl(n.reserve128, o.reserve128) as reserve128 -- 备用字段128
    ,nvl(n.reserve129, o.reserve129) as reserve129 -- 备用字段129
    ,nvl(n.reserve130, o.reserve130) as reserve130 -- 备用字段130
    ,nvl(n.reserve131, o.reserve131) as reserve131 -- 备用字段131
    ,nvl(n.reserve132, o.reserve132) as reserve132 -- 备用字段132
    ,nvl(n.reserve133, o.reserve133) as reserve133 -- 备用字段133
    ,nvl(n.reserve134, o.reserve134) as reserve134 -- 备用字段134
    ,nvl(n.reserve135, o.reserve135) as reserve135 -- 备用字段135
    ,nvl(n.reserve136, o.reserve136) as reserve136 -- 备用字段136
    ,nvl(n.reserve137, o.reserve137) as reserve137 -- 备用字段137
    ,nvl(n.reserve138, o.reserve138) as reserve138 -- 备用字段138
    ,nvl(n.reserve139, o.reserve139) as reserve139 -- 备用字段139
    ,nvl(n.reserve140, o.reserve140) as reserve140 -- 备用字段140
    ,nvl(n.reserve141, o.reserve141) as reserve141 -- 备用字段141
    ,nvl(n.reserve142, o.reserve142) as reserve142 -- 备用字段142
    ,nvl(n.reserve143, o.reserve143) as reserve143 -- 备用字段143
    ,nvl(n.reserve144, o.reserve144) as reserve144 -- 备用字段144
    ,nvl(n.reserve145, o.reserve145) as reserve145 -- 备用字段145
    ,nvl(n.reserve146, o.reserve146) as reserve146 -- 备用字段146
    ,case when
            n.logicalcardno is null
            and n.refnbr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.logicalcardno is null
            and n.refnbr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.logicalcardno is null
            and n.refnbr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_report_ds_loan_receipt_additional_info_day where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.logicalcardno = n.logicalcardno
            and o.refnbr = n.refnbr
where (
        o.logicalcardno is null
        and o.refnbr is null
    )
    or (
        n.logicalcardno is null
        and n.refnbr is null
    )
    or (
        o.partitiondate <> n.partitiondate
        or o.loanreceiptnbr <> n.loanreceiptnbr
        or o.loanusage <> n.loanusage
        or o.customertype <> n.customertype
        or o.loanprocessflag <> n.loanprocessflag
        or o.assetplanno <> n.assetplanno
        or o.lastbankgroupid <> n.lastbankgroupid
        or o.integererestrate <> n.integererestrate
        or o.lpr <> n.lpr
        or o.lprdate <> n.lprdate
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
        or o.reserve5 <> n.reserve5
        or o.reserve6 <> n.reserve6
        or o.reserve7 <> n.reserve7
        or o.loantype <> n.loantype
        or o.reserve9 <> n.reserve9
        or o.reserve10 <> n.reserve10
        or o.identifytype <> n.identifytype
        or o.remainprinamtob <> n.remainprinamtob
        or o.reserve13 <> n.reserve13
        or o.reserve14 <> n.reserve14
        or o.reserve15 <> n.reserve15
        or o.reserve16 <> n.reserve16
        or o.reserve17 <> n.reserve17
        or o.reserve18 <> n.reserve18
        or o.reserve19 <> n.reserve19
        or o.reserve20 <> n.reserve20
        or o.reserve21 <> n.reserve21
        or o.reserve22 <> n.reserve22
        or o.reserve23 <> n.reserve23
        or o.reserve24 <> n.reserve24
        or o.reserve25 <> n.reserve25
        or o.reserve26 <> n.reserve26
        or o.reserve27 <> n.reserve27
        or o.reserve28 <> n.reserve28
        or o.reserve29 <> n.reserve29
        or o.reserve30 <> n.reserve30
        or o.reserve31 <> n.reserve31
        or o.reserve32 <> n.reserve32
        or o.reserve33 <> n.reserve33
        or o.reserve34 <> n.reserve34
        or o.reserve35 <> n.reserve35
        or o.reserve36 <> n.reserve36
        or o.reserve37 <> n.reserve37
        or o.reserve38 <> n.reserve38
        or o.reserve39 <> n.reserve39
        or o.reserve40 <> n.reserve40
        or o.reserve41 <> n.reserve41
        or o.reserve42 <> n.reserve42
        or o.reserve43 <> n.reserve43
        or o.reserve44 <> n.reserve44
        or o.reserve45 <> n.reserve45
        or o.reserve46 <> n.reserve46
        or o.reserve47 <> n.reserve47
        or o.reserve48 <> n.reserve48
        or o.reserve49 <> n.reserve49
        or o.reserve50 <> n.reserve50
        or o.reserve51 <> n.reserve51
        or o.reserve52 <> n.reserve52
        or o.reserve53 <> n.reserve53
        or o.reserve54 <> n.reserve54
        or o.reserve55 <> n.reserve55
        or o.reserve56 <> n.reserve56
        or o.reserve57 <> n.reserve57
        or o.reserve58 <> n.reserve58
        or o.reserve59 <> n.reserve59
        or o.reserve60 <> n.reserve60
        or o.reserve61 <> n.reserve61
        or o.reserve62 <> n.reserve62
        or o.reserve63 <> n.reserve63
        or o.reserve64 <> n.reserve64
        or o.reserve65 <> n.reserve65
        or o.reserve66 <> n.reserve66
        or o.reserve67 <> n.reserve67
        or o.reserve68 <> n.reserve68
        or o.reserve69 <> n.reserve69
        or o.reserve70 <> n.reserve70
        or o.reserve71 <> n.reserve71
        or o.reserve72 <> n.reserve72
        or o.reserve73 <> n.reserve73
        or o.reserve74 <> n.reserve74
        or o.reserve75 <> n.reserve75
        or o.reserve76 <> n.reserve76
        or o.reserve77 <> n.reserve77
        or o.reserve78 <> n.reserve78
        or o.reserve79 <> n.reserve79
        or o.reserve80 <> n.reserve80
        or o.reserve81 <> n.reserve81
        or o.reserve82 <> n.reserve82
        or o.reserve83 <> n.reserve83
        or o.reserve84 <> n.reserve84
        or o.reserve85 <> n.reserve85
        or o.reserve86 <> n.reserve86
        or o.reserve87 <> n.reserve87
        or o.reserve88 <> n.reserve88
        or o.reserve89 <> n.reserve89
        or o.reserve90 <> n.reserve90
        or o.reserve91 <> n.reserve91
        or o.reserve92 <> n.reserve92
        or o.reserve93 <> n.reserve93
        or o.reserve94 <> n.reserve94
        or o.reserve95 <> n.reserve95
        or o.reserve96 <> n.reserve96
        or o.reserve97 <> n.reserve97
        or o.reserve98 <> n.reserve98
        or o.reserve99 <> n.reserve99
        or o.reserve100 <> n.reserve100
        or o.reserve101 <> n.reserve101
        or o.reserve102 <> n.reserve102
        or o.reserve103 <> n.reserve103
        or o.reserve104 <> n.reserve104
        or o.reserve105 <> n.reserve105
        or o.reserve106 <> n.reserve106
        or o.reserve107 <> n.reserve107
        or o.reserve108 <> n.reserve108
        or o.reserve109 <> n.reserve109
        or o.reserve110 <> n.reserve110
        or o.reserve111 <> n.reserve111
        or o.reserve112 <> n.reserve112
        or o.reserve113 <> n.reserve113
        or o.reserve114 <> n.reserve114
        or o.reserve115 <> n.reserve115
        or o.reserve116 <> n.reserve116
        or o.reserve117 <> n.reserve117
        or o.reserve118 <> n.reserve118
        or o.reserve119 <> n.reserve119
        or o.reserve120 <> n.reserve120
        or o.reserve121 <> n.reserve121
        or o.reserve122 <> n.reserve122
        or o.reserve123 <> n.reserve123
        or o.reserve124 <> n.reserve124
        or o.reserve125 <> n.reserve125
        or o.reserve126 <> n.reserve126
        or o.reserve127 <> n.reserve127
        or o.reserve128 <> n.reserve128
        or o.reserve129 <> n.reserve129
        or o.reserve130 <> n.reserve130
        or o.reserve131 <> n.reserve131
        or o.reserve132 <> n.reserve132
        or o.reserve133 <> n.reserve133
        or o.reserve134 <> n.reserve134
        or o.reserve135 <> n.reserve135
        or o.reserve136 <> n.reserve136
        or o.reserve137 <> n.reserve137
        or o.reserve138 <> n.reserve138
        or o.reserve139 <> n.reserve139
        or o.reserve140 <> n.reserve140
        or o.reserve141 <> n.reserve141
        or o.reserve142 <> n.reserve142
        or o.reserve143 <> n.reserve143
        or o.reserve144 <> n.reserve144
        or o.reserve145 <> n.reserve145
        or o.reserve146 <> n.reserve146
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_cl(
            partitiondate -- 批量日期
            ,logicalcardno -- 逻辑卡号
            ,loanreceiptnbr -- 借据号
            ,loanusage -- 贷款用途
            ,customertype -- 借款人身份
            ,loanprocessflag -- 借据标识
            ,assetplanno -- 资产计划号
            ,lastbankgroupid -- 初始参贷方案
            ,refnbr -- 交易参考号
            ,integererestrate -- 实际执行的年化利率（360天）
            ,lpr -- 当期lpr值
            ,lprdate -- lpr公布日期
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,reserve7 -- 备用字段7
            ,loantype -- 还款方式
            ,reserve9 -- 被操作交易参考号
            ,reserve10 -- 操作时间
            ,identifytype -- 客户身份
            ,remainprinamtob -- 归属于合作机构的本金余额
            ,reserve13 -- 备用字段13
            ,reserve14 -- 客户收款银行名称（仅有收款行为出资行时有值）
            ,reserve15 -- 客户收款银行行号（仅有收款行为出资行时有值）
            ,reserve16 -- 客户收款账号（仅有收款行为出资行时有值）
            ,reserve17 -- 借款用途
            ,reserve18 -- 客户号
            ,reserve19 -- 借款合同名称
            ,reserve20 -- 借据起始日期
            ,reserve21 -- 借据原始到期日
            ,reserve22 -- 借据结清日期
            ,reserve23 -- 备用字段23
            ,reserve24 -- 备用字段24
            ,reserve25 -- 备用字段25
            ,reserve26 -- 备用字段26
            ,reserve27 -- 备用字段27
            ,reserve28 -- 备用字段28
            ,reserve29 -- 备用字段29
            ,reserve30 -- 备用字段30
            ,reserve31 -- 备用字段31
            ,reserve32 -- 备用字段32
            ,reserve33 -- 备用字段33
            ,reserve34 -- 备用字段34
            ,reserve35 -- 备用字段35
            ,reserve36 -- 备用字段36
            ,reserve37 -- 备用字段37
            ,reserve38 -- 备用字段38
            ,reserve39 -- 备用字段39
            ,reserve40 -- 备用字段40
            ,reserve41 -- 备用字段41
            ,reserve42 -- 备用字段42
            ,reserve43 -- 备用字段43
            ,reserve44 -- 备用字段44
            ,reserve45 -- 备用字段45
            ,reserve46 -- 备用字段46
            ,reserve47 -- 备用字段47
            ,reserve48 -- 备用字段48
            ,reserve49 -- 备用字段49
            ,reserve50 -- 备用字段50
            ,reserve51 -- 备用字段51
            ,reserve52 -- 备用字段52
            ,reserve53 -- 备用字段53
            ,reserve54 -- 备用字段54
            ,reserve55 -- 备用字段55
            ,reserve56 -- 备用字段56
            ,reserve57 -- 备用字段57
            ,reserve58 -- 备用字段58
            ,reserve59 -- 备用字段59
            ,reserve60 -- 备用字段60
            ,reserve61 -- 备用字段61
            ,reserve62 -- 备用字段62
            ,reserve63 -- 备用字段63
            ,reserve64 -- 备用字段64
            ,reserve65 -- 备用字段65
            ,reserve66 -- 备用字段66
            ,reserve67 -- 备用字段67
            ,reserve68 -- 备用字段68
            ,reserve69 -- 备用字段69
            ,reserve70 -- 备用字段70
            ,reserve71 -- 备用字段71
            ,reserve72 -- 备用字段72
            ,reserve73 -- 备用字段73
            ,reserve74 -- 备用字段74
            ,reserve75 -- 备用字段75
            ,reserve76 -- 备用字段76
            ,reserve77 -- 备用字段77
            ,reserve78 -- 备用字段78
            ,reserve79 -- 备用字段79
            ,reserve80 -- 备用字段80
            ,reserve81 -- 备用字段81
            ,reserve82 -- 备用字段82
            ,reserve83 -- 备用字段83
            ,reserve84 -- 备用字段84
            ,reserve85 -- 备用字段85
            ,reserve86 -- 备用字段86
            ,reserve87 -- 备用字段87
            ,reserve88 -- 备用字段88
            ,reserve89 -- 备用字段89
            ,reserve90 -- 备用字段90
            ,reserve91 -- 备用字段91
            ,reserve92 -- 备用字段92
            ,reserve93 -- 备用字段93
            ,reserve94 -- 备用字段94
            ,reserve95 -- 备用字段95
            ,reserve96 -- 备用字段96
            ,reserve97 -- 备用字段97
            ,reserve98 -- 备用字段98
            ,reserve99 -- 备用字段99
            ,reserve100 -- 备用字段100
            ,reserve101 -- 备用字段101
            ,reserve102 -- 备用字段102
            ,reserve103 -- 备用字段103
            ,reserve104 -- 备用字段104
            ,reserve105 -- 备用字段105
            ,reserve106 -- 备用字段106
            ,reserve107 -- 备用字段107
            ,reserve108 -- 备用字段108
            ,reserve109 -- 备用字段109
            ,reserve110 -- 备用字段110
            ,reserve111 -- 备用字段111
            ,reserve112 -- 备用字段112
            ,reserve113 -- 备用字段113
            ,reserve114 -- 备用字段114
            ,reserve115 -- 备用字段115
            ,reserve116 -- 备用字段116
            ,reserve117 -- 备用字段117
            ,reserve118 -- 备用字段118
            ,reserve119 -- 备用字段119
            ,reserve120 -- 备用字段120
            ,reserve121 -- 备用字段121
            ,reserve122 -- 备用字段122
            ,reserve123 -- 备用字段123
            ,reserve124 -- 备用字段124
            ,reserve125 -- 备用字段125
            ,reserve126 -- 备用字段126
            ,reserve127 -- 备用字段127
            ,reserve128 -- 备用字段128
            ,reserve129 -- 备用字段129
            ,reserve130 -- 备用字段130
            ,reserve131 -- 备用字段131
            ,reserve132 -- 备用字段132
            ,reserve133 -- 备用字段133
            ,reserve134 -- 备用字段134
            ,reserve135 -- 备用字段135
            ,reserve136 -- 备用字段136
            ,reserve137 -- 备用字段137
            ,reserve138 -- 备用字段138
            ,reserve139 -- 备用字段139
            ,reserve140 -- 备用字段140
            ,reserve141 -- 备用字段141
            ,reserve142 -- 备用字段142
            ,reserve143 -- 备用字段143
            ,reserve144 -- 备用字段144
            ,reserve145 -- 备用字段145
            ,reserve146 -- 备用字段146
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_op(
            partitiondate -- 批量日期
            ,logicalcardno -- 逻辑卡号
            ,loanreceiptnbr -- 借据号
            ,loanusage -- 贷款用途
            ,customertype -- 借款人身份
            ,loanprocessflag -- 借据标识
            ,assetplanno -- 资产计划号
            ,lastbankgroupid -- 初始参贷方案
            ,refnbr -- 交易参考号
            ,integererestrate -- 实际执行的年化利率（360天）
            ,lpr -- 当期lpr值
            ,lprdate -- lpr公布日期
            ,reserve1 -- 备用字段1
            ,reserve2 -- 备用字段2
            ,reserve3 -- 备用字段3
            ,reserve4 -- 备用字段4
            ,reserve5 -- 备用字段5
            ,reserve6 -- 备用字段6
            ,reserve7 -- 备用字段7
            ,loantype -- 还款方式
            ,reserve9 -- 被操作交易参考号
            ,reserve10 -- 操作时间
            ,identifytype -- 客户身份
            ,remainprinamtob -- 归属于合作机构的本金余额
            ,reserve13 -- 备用字段13
            ,reserve14 -- 客户收款银行名称（仅有收款行为出资行时有值）
            ,reserve15 -- 客户收款银行行号（仅有收款行为出资行时有值）
            ,reserve16 -- 客户收款账号（仅有收款行为出资行时有值）
            ,reserve17 -- 借款用途
            ,reserve18 -- 客户号
            ,reserve19 -- 借款合同名称
            ,reserve20 -- 借据起始日期
            ,reserve21 -- 借据原始到期日
            ,reserve22 -- 借据结清日期
            ,reserve23 -- 备用字段23
            ,reserve24 -- 备用字段24
            ,reserve25 -- 备用字段25
            ,reserve26 -- 备用字段26
            ,reserve27 -- 备用字段27
            ,reserve28 -- 备用字段28
            ,reserve29 -- 备用字段29
            ,reserve30 -- 备用字段30
            ,reserve31 -- 备用字段31
            ,reserve32 -- 备用字段32
            ,reserve33 -- 备用字段33
            ,reserve34 -- 备用字段34
            ,reserve35 -- 备用字段35
            ,reserve36 -- 备用字段36
            ,reserve37 -- 备用字段37
            ,reserve38 -- 备用字段38
            ,reserve39 -- 备用字段39
            ,reserve40 -- 备用字段40
            ,reserve41 -- 备用字段41
            ,reserve42 -- 备用字段42
            ,reserve43 -- 备用字段43
            ,reserve44 -- 备用字段44
            ,reserve45 -- 备用字段45
            ,reserve46 -- 备用字段46
            ,reserve47 -- 备用字段47
            ,reserve48 -- 备用字段48
            ,reserve49 -- 备用字段49
            ,reserve50 -- 备用字段50
            ,reserve51 -- 备用字段51
            ,reserve52 -- 备用字段52
            ,reserve53 -- 备用字段53
            ,reserve54 -- 备用字段54
            ,reserve55 -- 备用字段55
            ,reserve56 -- 备用字段56
            ,reserve57 -- 备用字段57
            ,reserve58 -- 备用字段58
            ,reserve59 -- 备用字段59
            ,reserve60 -- 备用字段60
            ,reserve61 -- 备用字段61
            ,reserve62 -- 备用字段62
            ,reserve63 -- 备用字段63
            ,reserve64 -- 备用字段64
            ,reserve65 -- 备用字段65
            ,reserve66 -- 备用字段66
            ,reserve67 -- 备用字段67
            ,reserve68 -- 备用字段68
            ,reserve69 -- 备用字段69
            ,reserve70 -- 备用字段70
            ,reserve71 -- 备用字段71
            ,reserve72 -- 备用字段72
            ,reserve73 -- 备用字段73
            ,reserve74 -- 备用字段74
            ,reserve75 -- 备用字段75
            ,reserve76 -- 备用字段76
            ,reserve77 -- 备用字段77
            ,reserve78 -- 备用字段78
            ,reserve79 -- 备用字段79
            ,reserve80 -- 备用字段80
            ,reserve81 -- 备用字段81
            ,reserve82 -- 备用字段82
            ,reserve83 -- 备用字段83
            ,reserve84 -- 备用字段84
            ,reserve85 -- 备用字段85
            ,reserve86 -- 备用字段86
            ,reserve87 -- 备用字段87
            ,reserve88 -- 备用字段88
            ,reserve89 -- 备用字段89
            ,reserve90 -- 备用字段90
            ,reserve91 -- 备用字段91
            ,reserve92 -- 备用字段92
            ,reserve93 -- 备用字段93
            ,reserve94 -- 备用字段94
            ,reserve95 -- 备用字段95
            ,reserve96 -- 备用字段96
            ,reserve97 -- 备用字段97
            ,reserve98 -- 备用字段98
            ,reserve99 -- 备用字段99
            ,reserve100 -- 备用字段100
            ,reserve101 -- 备用字段101
            ,reserve102 -- 备用字段102
            ,reserve103 -- 备用字段103
            ,reserve104 -- 备用字段104
            ,reserve105 -- 备用字段105
            ,reserve106 -- 备用字段106
            ,reserve107 -- 备用字段107
            ,reserve108 -- 备用字段108
            ,reserve109 -- 备用字段109
            ,reserve110 -- 备用字段110
            ,reserve111 -- 备用字段111
            ,reserve112 -- 备用字段112
            ,reserve113 -- 备用字段113
            ,reserve114 -- 备用字段114
            ,reserve115 -- 备用字段115
            ,reserve116 -- 备用字段116
            ,reserve117 -- 备用字段117
            ,reserve118 -- 备用字段118
            ,reserve119 -- 备用字段119
            ,reserve120 -- 备用字段120
            ,reserve121 -- 备用字段121
            ,reserve122 -- 备用字段122
            ,reserve123 -- 备用字段123
            ,reserve124 -- 备用字段124
            ,reserve125 -- 备用字段125
            ,reserve126 -- 备用字段126
            ,reserve127 -- 备用字段127
            ,reserve128 -- 备用字段128
            ,reserve129 -- 备用字段129
            ,reserve130 -- 备用字段130
            ,reserve131 -- 备用字段131
            ,reserve132 -- 备用字段132
            ,reserve133 -- 备用字段133
            ,reserve134 -- 备用字段134
            ,reserve135 -- 备用字段135
            ,reserve136 -- 备用字段136
            ,reserve137 -- 备用字段137
            ,reserve138 -- 备用字段138
            ,reserve139 -- 备用字段139
            ,reserve140 -- 备用字段140
            ,reserve141 -- 备用字段141
            ,reserve142 -- 备用字段142
            ,reserve143 -- 备用字段143
            ,reserve144 -- 备用字段144
            ,reserve145 -- 备用字段145
            ,reserve146 -- 备用字段146
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.partitiondate -- 批量日期
    ,o.logicalcardno -- 逻辑卡号
    ,o.loanreceiptnbr -- 借据号
    ,o.loanusage -- 贷款用途
    ,o.customertype -- 借款人身份
    ,o.loanprocessflag -- 借据标识
    ,o.assetplanno -- 资产计划号
    ,o.lastbankgroupid -- 初始参贷方案
    ,o.refnbr -- 交易参考号
    ,o.integererestrate -- 实际执行的年化利率（360天）
    ,o.lpr -- 当期lpr值
    ,o.lprdate -- lpr公布日期
    ,o.reserve1 -- 备用字段1
    ,o.reserve2 -- 备用字段2
    ,o.reserve3 -- 备用字段3
    ,o.reserve4 -- 备用字段4
    ,o.reserve5 -- 备用字段5
    ,o.reserve6 -- 备用字段6
    ,o.reserve7 -- 备用字段7
    ,o.loantype -- 还款方式
    ,o.reserve9 -- 被操作交易参考号
    ,o.reserve10 -- 操作时间
    ,o.identifytype -- 客户身份
    ,o.remainprinamtob -- 归属于合作机构的本金余额
    ,o.reserve13 -- 备用字段13
    ,o.reserve14 -- 客户收款银行名称（仅有收款行为出资行时有值）
    ,o.reserve15 -- 客户收款银行行号（仅有收款行为出资行时有值）
    ,o.reserve16 -- 客户收款账号（仅有收款行为出资行时有值）
    ,o.reserve17 -- 借款用途
    ,o.reserve18 -- 客户号
    ,o.reserve19 -- 借款合同名称
    ,o.reserve20 -- 借据起始日期
    ,o.reserve21 -- 借据原始到期日
    ,o.reserve22 -- 借据结清日期
    ,o.reserve23 -- 备用字段23
    ,o.reserve24 -- 备用字段24
    ,o.reserve25 -- 备用字段25
    ,o.reserve26 -- 备用字段26
    ,o.reserve27 -- 备用字段27
    ,o.reserve28 -- 备用字段28
    ,o.reserve29 -- 备用字段29
    ,o.reserve30 -- 备用字段30
    ,o.reserve31 -- 备用字段31
    ,o.reserve32 -- 备用字段32
    ,o.reserve33 -- 备用字段33
    ,o.reserve34 -- 备用字段34
    ,o.reserve35 -- 备用字段35
    ,o.reserve36 -- 备用字段36
    ,o.reserve37 -- 备用字段37
    ,o.reserve38 -- 备用字段38
    ,o.reserve39 -- 备用字段39
    ,o.reserve40 -- 备用字段40
    ,o.reserve41 -- 备用字段41
    ,o.reserve42 -- 备用字段42
    ,o.reserve43 -- 备用字段43
    ,o.reserve44 -- 备用字段44
    ,o.reserve45 -- 备用字段45
    ,o.reserve46 -- 备用字段46
    ,o.reserve47 -- 备用字段47
    ,o.reserve48 -- 备用字段48
    ,o.reserve49 -- 备用字段49
    ,o.reserve50 -- 备用字段50
    ,o.reserve51 -- 备用字段51
    ,o.reserve52 -- 备用字段52
    ,o.reserve53 -- 备用字段53
    ,o.reserve54 -- 备用字段54
    ,o.reserve55 -- 备用字段55
    ,o.reserve56 -- 备用字段56
    ,o.reserve57 -- 备用字段57
    ,o.reserve58 -- 备用字段58
    ,o.reserve59 -- 备用字段59
    ,o.reserve60 -- 备用字段60
    ,o.reserve61 -- 备用字段61
    ,o.reserve62 -- 备用字段62
    ,o.reserve63 -- 备用字段63
    ,o.reserve64 -- 备用字段64
    ,o.reserve65 -- 备用字段65
    ,o.reserve66 -- 备用字段66
    ,o.reserve67 -- 备用字段67
    ,o.reserve68 -- 备用字段68
    ,o.reserve69 -- 备用字段69
    ,o.reserve70 -- 备用字段70
    ,o.reserve71 -- 备用字段71
    ,o.reserve72 -- 备用字段72
    ,o.reserve73 -- 备用字段73
    ,o.reserve74 -- 备用字段74
    ,o.reserve75 -- 备用字段75
    ,o.reserve76 -- 备用字段76
    ,o.reserve77 -- 备用字段77
    ,o.reserve78 -- 备用字段78
    ,o.reserve79 -- 备用字段79
    ,o.reserve80 -- 备用字段80
    ,o.reserve81 -- 备用字段81
    ,o.reserve82 -- 备用字段82
    ,o.reserve83 -- 备用字段83
    ,o.reserve84 -- 备用字段84
    ,o.reserve85 -- 备用字段85
    ,o.reserve86 -- 备用字段86
    ,o.reserve87 -- 备用字段87
    ,o.reserve88 -- 备用字段88
    ,o.reserve89 -- 备用字段89
    ,o.reserve90 -- 备用字段90
    ,o.reserve91 -- 备用字段91
    ,o.reserve92 -- 备用字段92
    ,o.reserve93 -- 备用字段93
    ,o.reserve94 -- 备用字段94
    ,o.reserve95 -- 备用字段95
    ,o.reserve96 -- 备用字段96
    ,o.reserve97 -- 备用字段97
    ,o.reserve98 -- 备用字段98
    ,o.reserve99 -- 备用字段99
    ,o.reserve100 -- 备用字段100
    ,o.reserve101 -- 备用字段101
    ,o.reserve102 -- 备用字段102
    ,o.reserve103 -- 备用字段103
    ,o.reserve104 -- 备用字段104
    ,o.reserve105 -- 备用字段105
    ,o.reserve106 -- 备用字段106
    ,o.reserve107 -- 备用字段107
    ,o.reserve108 -- 备用字段108
    ,o.reserve109 -- 备用字段109
    ,o.reserve110 -- 备用字段110
    ,o.reserve111 -- 备用字段111
    ,o.reserve112 -- 备用字段112
    ,o.reserve113 -- 备用字段113
    ,o.reserve114 -- 备用字段114
    ,o.reserve115 -- 备用字段115
    ,o.reserve116 -- 备用字段116
    ,o.reserve117 -- 备用字段117
    ,o.reserve118 -- 备用字段118
    ,o.reserve119 -- 备用字段119
    ,o.reserve120 -- 备用字段120
    ,o.reserve121 -- 备用字段121
    ,o.reserve122 -- 备用字段122
    ,o.reserve123 -- 备用字段123
    ,o.reserve124 -- 备用字段124
    ,o.reserve125 -- 备用字段125
    ,o.reserve126 -- 备用字段126
    ,o.reserve127 -- 备用字段127
    ,o.reserve128 -- 备用字段128
    ,o.reserve129 -- 备用字段129
    ,o.reserve130 -- 备用字段130
    ,o.reserve131 -- 备用字段131
    ,o.reserve132 -- 备用字段132
    ,o.reserve133 -- 备用字段133
    ,o.reserve134 -- 备用字段134
    ,o.reserve135 -- 备用字段135
    ,o.reserve136 -- 备用字段136
    ,o.reserve137 -- 备用字段137
    ,o.reserve138 -- 备用字段138
    ,o.reserve139 -- 备用字段139
    ,o.reserve140 -- 备用字段140
    ,o.reserve141 -- 备用字段141
    ,o.reserve142 -- 备用字段142
    ,o.reserve143 -- 备用字段143
    ,o.reserve144 -- 备用字段144
    ,o.reserve145 -- 备用字段145
    ,o.reserve146 -- 备用字段146
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
from ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_bk o
    left join ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_op n
        on
            o.logicalcardno = n.logicalcardno
            and o.refnbr = n.refnbr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_cl d
        on
            o.logicalcardno = d.logicalcardno
            and o.refnbr = d.refnbr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_report_ds_loan_receipt_additional_info_day') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day exchange partition p_${batch_date} with table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_cl;
alter table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day exchange partition p_20991231 with table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_op purge;
drop table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_report_ds_loan_receipt_additional_info_day_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_report_ds_loan_receipt_additional_info_day',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
