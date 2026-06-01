/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0nwldzqinfo
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0nwldzqinfo_ex purge;
alter table ${iol_schema}.mpcs_a0nwldzqinfo add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.mpcs_a0nwldzqinfo truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.mpcs_a0nwldzqinfo_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0nwldzqinfo where 0=1;

insert /*+ append */ into ${iol_schema}.mpcs_a0nwldzqinfo_ex(
    partition_date -- 批量日期
    ,logical_card_no -- 逻辑卡号
    ,loan_receipt_nbr -- 借据号
    ,loan_usage -- 贷款用途
    ,customer_type -- 借款人身份
    ,loan_process_flag -- 借据标识
    ,asset_plan_no -- 转让计划号
    ,last_bank_group_id -- 转让前初始银团
    ,ref_nbr -- 交易参考号
    ,interest_rate -- 实际执行的年化利率(360天)
    ,lpr -- 当期LPR值
    ,lpr_date -- LPR公布日期
    ,reserve5 -- 备用字段5
    ,reserve6 -- 备用字段6
    ,reserve7 -- 备用字段7
    ,reserve8 -- 备用字段8
    ,reserve9 -- 备用字段9
    ,reserve10 -- 备用字段10
    ,reserve11 -- 备用字段11
    ,reserve12 -- 备用字段12
    ,reserve13 -- 备用字段13
    ,reserve14 -- 备用字段14
    ,reserve15 -- 备用字段15
    ,reserve16 -- 备用字段16
    ,reserve17 -- 备用字段17
    ,reserve18 -- 备用字段18
    ,reserve19 -- 备用字段19
    ,reserve20 -- 备用字段20
    ,reserve21 -- 备用字段21
    ,reserve22 -- 备用字段22
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
    ,reserve147 -- 备用字段147
    ,reserve148 -- 备用字段148
    ,reserve149 -- 备用字段149
    ,reserve150 -- 备用字段150
    ,batchfilename -- 批量文件名
    ,seqno -- 序列号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    partition_date -- 批量日期
    ,logical_card_no -- 逻辑卡号
    ,loan_receipt_nbr -- 借据号
    ,loan_usage -- 贷款用途
    ,customer_type -- 借款人身份
    ,loan_process_flag -- 借据标识
    ,asset_plan_no -- 转让计划号
    ,last_bank_group_id -- 转让前初始银团
    ,ref_nbr -- 交易参考号
    ,interest_rate -- 实际执行的年化利率(360天)
    ,lpr -- 当期LPR值
    ,lpr_date -- LPR公布日期
    ,reserve5 -- 备用字段5
    ,reserve6 -- 备用字段6
    ,reserve7 -- 备用字段7
    ,reserve8 -- 备用字段8
    ,reserve9 -- 备用字段9
    ,reserve10 -- 备用字段10
    ,reserve11 -- 备用字段11
    ,reserve12 -- 备用字段12
    ,reserve13 -- 备用字段13
    ,reserve14 -- 备用字段14
    ,reserve15 -- 备用字段15
    ,reserve16 -- 备用字段16
    ,reserve17 -- 备用字段17
    ,reserve18 -- 备用字段18
    ,reserve19 -- 备用字段19
    ,reserve20 -- 备用字段20
    ,reserve21 -- 备用字段21
    ,reserve22 -- 备用字段22
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
    ,reserve147 -- 备用字段147
    ,reserve148 -- 备用字段148
    ,reserve149 -- 备用字段149
    ,reserve150 -- 备用字段150
    ,batchfilename -- 批量文件名
    ,seqno -- 序列号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.mpcs_a0nwldzqinfo
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.mpcs_a0nwldzqinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0nwldzqinfo_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0nwldzqinfo to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.mpcs_a0nwldzqinfo_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0nwldzqinfo',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);